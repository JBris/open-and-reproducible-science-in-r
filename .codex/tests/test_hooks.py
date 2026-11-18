"""Exercise lifecycle feedback in isolated repositories without model calls."""

import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


SOURCE_ROOT = Path(__file__).resolve().parents[2]


class ProjectHooksTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="workshop-hooks-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        for relative in (".codex/hooks/project.py", ".codex/scripts/check-r.R"):
            target = self.root / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(SOURCE_ROOT / relative, target)
        (self.root / "VERSION").write_text("1.0.0\n", encoding="utf-8")
        (self.root / "renv.lock").write_text(
            json.dumps({"R": {"Version": "4.4.2"}, "Packages": {}}), encoding="utf-8",
        )
        self.git("init", "--quiet")
        self.git("add", ".")
        self.git("-c", "user.name=Hook Test", "-c", "user.email=hooks@example.invalid",
                 "commit", "--quiet", "-m", "fixture", "--no-verify")

    def git(self, *args):
        return subprocess.run(
            ["git", *args], cwd=self.root, capture_output=True, text=True, check=True,
        )

    def hook(self, event, payload=None, cwd=None, raw=None):
        result = subprocess.run(
            [sys.executable, str(self.root / ".codex/hooks/project.py"), event],
            input=raw if raw is not None else json.dumps(payload or {}),
            cwd=cwd or self.root, capture_output=True, text=True, check=True,
        )
        return json.loads(result.stdout)

    def test_session_reports_versions_and_bootstrap_gaps(self):
        output = self.hook("session-start")
        context = output["hookSpecificOutput"]["additionalContext"]
        self.assertIn("1.0.0", context)
        self.assertIn("4.4.2", context)
        self.assertIn("renv/activate.R is absent", context)
        self.assertIn("no locked packages", context)
        self.assertFalse((self.root / "renv").exists())

    def test_clean_stop_is_silent_from_subdirectory(self):
        nested = self.root / "nested"
        nested.mkdir()
        self.assertEqual({}, self.hook("stop", cwd=nested))

    def test_whitespace_failure_is_advisory(self):
        (self.root / "VERSION").write_text("1.0.0 \n", encoding="utf-8")
        output = self.hook("stop")
        self.assertIn("whitespace", output["systemMessage"])
        self.assertNotIn("decision", output)
        self.assertNotIn("continue", output)

    @unittest.skipUnless(shutil.which("Rscript"), "Rscript is unavailable")
    def test_untracked_invalid_r_file_with_spaces_is_reported(self):
        script = self.root / "bad example.R"
        script.write_text("value <- (\n", encoding="utf-8")
        output = self.hook("stop")
        self.assertIn("R syntax check", output["systemMessage"])
        self.assertIn("bad example.R", output["systemMessage"])
        self.assertEqual("value <- (\n", script.read_text(encoding="utf-8"))

    @unittest.skipUnless(shutil.which("Rscript"), "Rscript is unavailable")
    def test_staged_invalid_r_file_is_reported(self):
        (self.root / "example.R").write_text("value <- (\n", encoding="utf-8")
        self.git("add", "example.R")
        self.assertIn("R syntax check", self.hook("stop")["systemMessage"])

    @unittest.skipUnless(shutil.which("Rscript"), "Rscript is unavailable")
    def test_valid_r_code_is_parsed_without_execution(self):
        (self.root / ".Rprofile").write_text('stop("startup must not run")\n', encoding="utf-8")
        (self.root / "example.R").write_text(
            'writeLines("executed", "unexpected-output.txt")\n', encoding="utf-8",
        )
        self.assertEqual({}, self.hook("stop"))
        self.assertFalse((self.root / "unexpected-output.txt").exists())

    def test_renv_and_site_r_files_are_excluded(self):
        for directory in ("renv", "_site", ".quarto"):
            target = self.root / directory / "generated.R"
            target.parent.mkdir()
            target.write_text("value <- (\n", encoding="utf-8")
        self.assertEqual({}, self.hook("stop"))

    def test_deleted_r_file_is_skipped(self):
        target = self.root / "example.R"
        target.write_text("value <- 1\n", encoding="utf-8")
        self.git("add", "example.R")
        self.git("-c", "user.name=Hook Test", "-c", "user.email=hooks@example.invalid",
                 "commit", "--quiet", "-m", "example", "--no-verify")
        target.unlink()
        self.assertEqual({}, self.hook("stop"))

    def test_continuation_does_not_repeat_checks(self):
        (self.root / "VERSION").write_text("1.0.0 \n", encoding="utf-8")
        self.assertEqual({}, self.hook("stop", {"stop_hook_active": True}))

    def test_malformed_input_returns_advisory_json(self):
        output = self.hook("stop", raw="not JSON")
        self.assertIn("could not complete", output["systemMessage"])


if __name__ == "__main__":
    unittest.main()
