#!/usr/bin/env python3
"""Codex lifecycle feedback using only Python's standard library and base R."""

import argparse
import json
from pathlib import Path
import shutil
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[2]


def run(command, timeout=5):
    return subprocess.run(
        command, cwd=ROOT, capture_output=True, text=True,
        encoding="utf-8", errors="replace", timeout=timeout, check=False,
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


def worktree_feedback():
    issues = []
    # HEAD covers both staged and unstaged edits in the final working tree.
    paths = run(["git", "diff", "--name-only", "-z", "HEAD", "--"])
    untracked = run(["git", "ls-files", "--others", "--exclude-standard", "-z"])
    if paths.returncode or untracked.returncode:
        return {"systemMessage": "Working tree checks unavailable: Git needs a repository with a HEAD commit."}

    whitespace = run(["git", "diff", "--check", "HEAD", "--"])
    if whitespace.returncode:
        detail = (whitespace.stdout + whitespace.stderr).strip()
        issues.append("Tracked whitespace check:\n" + detail[:2000])

    changed = set((paths.stdout + untracked.stdout).split("\0")) - {""}
    r_files = []
    for name in sorted(changed):
        path = ROOT / name
        if path.name != ".Rprofile" and path.suffix.lower() != ".r":
            continue
        if name.startswith(("renv/", "_site/", ".quarto/")):
            continue
        if path.is_file() and path.resolve().is_relative_to(ROOT):
            r_files.append(str(path))

    if r_files:
        rscript = shutil.which("Rscript")
        if rscript:
            result = run(
                [rscript, "--vanilla", str(ROOT / ".codex/scripts/check-r.R"), *r_files],
                timeout=20,
            )
            if result.returncode:
                detail = (result.stdout + result.stderr).strip()
                issues.append("R syntax check:\n" + detail[:2000])
        else:
            issues.append("R syntax check skipped: Rscript is unavailable for changed R files.")

    if not issues:
        return {}
    return {
        "systemMessage": (
            "Workshop checks (advisory; include pre-existing working tree edits):\n"
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
