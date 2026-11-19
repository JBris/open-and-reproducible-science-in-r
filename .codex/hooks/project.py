#!/usr/bin/env python3
"""Codex lifecycle feedback using only Python's standard library and base R."""

import argparse
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[2]


def run(command, timeout=5, *, binary=False):
    return subprocess.run(
        command, cwd=ROOT, capture_output=True, timeout=timeout, check=False,
        encoding=None if binary else "utf-8",
        errors=None if binary else "replace",
    )


def session_context():
    version_file = ROOT / "VERSION"
    version = version_file.read_text(encoding="utf-8").strip() if version_file.is_file() else "missing"
    lockfile = ROOT / "renv.lock"
    lock = json.loads(lockfile.read_text(encoding="utf-8")) if lockfile.is_file() else {}
    r_version = lock.get("R", {}).get("Version", "unspecified")
    tools = ", ".join(
        f"{name}: {'available' if shutil.which(name) else 'missing'}"
        for name in ("Rscript", "quarto", "docker")
    )
    context = [
        f"Workshop release: {version}. R version in renv.lock: {r_version}.",
        tools + ". Executable availability does not verify tool or daemon health.",
    ]
    if not (ROOT / "renv/activate.R").is_file():
        context.append(
            "renv/activate.R is absent. Project .Rprofile cannot activate renv; "
            "use Rscript --vanilla for dependency-free checks and report this "
            "limitation for project execution."
        )
    if not lock.get("Packages"):
        context.append("renv.lock has no locked packages; do not assume dependencies are restored.")
    return {
        "hookSpecificOutput": {
            "hookEventName": "SessionStart",
            "additionalContext": "\n".join(context),
        }
    }


def is_r_source(name):
    path = Path(name)
    return (
        (path.name == ".Rprofile" or path.suffix.lower() == ".r")
        and not name.startswith(("renv/", "_site/", ".quarto/"))
    )


def staged_r_sources(raw_diff):
    records = raw_diff.split("\0")
    for header, name in zip(records[::2], records[1::2]):
        _, mode, _, oid, _ = header.split()
        if mode in ("100644", "100755") and is_r_source(name):
            yield name, oid


def r_syntax_feedback(worktree, staged):
    rscript = shutil.which("Rscript")
    if not rscript:
        return "R syntax check skipped: Rscript is unavailable for changed R files."

    with tempfile.TemporaryDirectory(prefix="workshop-index-") as directory:
        staged_root = Path(directory)
        staged_files = []
        for name, oid in staged:
            # The blob is the committed candidate, even if the file on disk differs.
            blob = run(["git", "cat-file", "blob", oid], binary=True)
            if blob.returncode:
                raise ValueError(f"could not read staged R file {name!r}")
            path = staged_root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(blob.stdout)
            staged_files.append(str(path))

        result = run(
            [rscript, "--vanilla", str(ROOT / ".codex/scripts/check-r.R"),
             *worktree, *staged_files],
            timeout=20,
        )
        if result.returncode:
            detail = (result.stdout + result.stderr).strip()
            detail = detail.replace(f"{staged_root}/", "[staged] ")
            return "R syntax check:\n" + detail[:2000]
    return ""


def worktree_feedback():
    issues = []
    staged = run(["git", "diff", "--cached", "--raw", "--no-abbrev",
                  "--no-renames", "--diff-filter=AMT", "-z", "HEAD", "--"])
    paths = run(["git", "diff", "--name-only", "-z", "--"])
    untracked = run(["git", "ls-files", "--others", "--exclude-standard", "-z"])
    if staged.returncode or paths.returncode or untracked.returncode:
        return {"systemMessage": "Git checks unavailable: verify the repository and its HEAD commit."}

    for label, options in (("Staged", ["--cached"]), ("Working tree", [])):
        whitespace = run(["git", "diff", *options, "--check", "--"])
        if whitespace.returncode:
            detail = (whitespace.stdout + whitespace.stderr).strip()
            issues.append(f"{label} whitespace check:\n" + detail[:2000])

    changed = set((paths.stdout + untracked.stdout).split("\0")) - {""}
    worktree_r = []
    for name in sorted(changed):
        path = ROOT / name
        if is_r_source(name) and path.is_file() and path.resolve().is_relative_to(ROOT):
            worktree_r.append(str(path))

    staged_r = list(staged_r_sources(staged.stdout))
    if worktree_r or staged_r:
        feedback = r_syntax_feedback(worktree_r, staged_r)
        if feedback:
            issues.append(feedback)

    if not issues:
        return {}
    return {
        "systemMessage": (
            "Workshop checks (advisory; include pre-existing changes):\n"
            + "\n".join(issues)
            + "\nThese checks do not execute R examples or validate rendered documents."
        )
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("event", choices=("session-start", "stop"))
    args = parser.parse_args()
    try:
        payload = json.load(sys.stdin)
        if not isinstance(payload, dict):
            raise ValueError("hook input must be a JSON object")
        if args.event == "session-start":
            output = session_context()
        elif payload.get("stop_hook_active"):
            output = {}
        else:
            output = worktree_feedback()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        output = {"systemMessage": f"Workshop hook could not complete: {error}"}
    # Stop hooks require JSON. Feedback is advisory and never creates a retry loop.
    print(json.dumps(output))


if __name__ == "__main__":
    main()
