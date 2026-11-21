# Claude Code development setup

This directory gives Claude Code the same project setup that `.codex/` gives
Codex. Both share `AGENTS.md`, the skills in `.agents/skills/`, and the hook and
R checker scripts in `.codex/`, so the two setups stay consistent. Python 3.9+
is needed for the hook script and Rscript for syntax checks. Neither installs
additional packages.

## Files and responsibilities

| Location | Purpose |
| --- | --- |
| `AGENTS.md` | Project conventions, commands, and verification expectations |
| `CLAUDE.md` | Imports `AGENTS.md` so Claude Code loads the shared instructions |
| `AI_POLICY.md` | Human responsibility, AI assistance disclosure, and scientific verification |
| `.claude/agents/*.md` | R developer, lesson editor, read-only reviewer, and AIMOS2026 attendee subagents |
| `.claude/settings.json` | SessionStart and Stop hooks, and approval prompts for image publishing |
| `.agents/skills/*/SKILL.md` | Shared R, Quarto, and container procedures (also used by Codex) |
| `.codex/hooks/project.py` | Shared lifecycle feedback script, which does not modify source files |
| `.codex/scripts/check-r.R` | Shared R parser that checks syntax without running code |
| `.codex/tests/test_hooks.py` | Hook behavior checks using temporary repositories |

## Start using it

Launch `claude` from this checkout. Claude Code loads `.claude/settings.json`
for the project. Review the hooks with `/hooks` before relying on them. Keep
personal overrides in `.claude/settings.local.json`, which should not be
committed.

Read the root [AI-assisted development policy](../AI_POLICY.md) when preparing
a contribution. Agents can carry out assigned local work and prepare drafts;
report their checks separately from human review.

Claude Code does not discover skills in `.agents/skills/` automatically, so ask
for them by path:

```text
Follow .agents/skills/r-reproducibility/SKILL.md to add a reproducible example
for missing-value handling.
```

To delegate, ask for named subagents and bounded tasks:

```text
Use the r-developer agent to implement the assigned helper in R/dummy.R and the
lesson-editor agent to update its explanation in pages/1_introduction.qmd. Give
each agent ownership of its file. Then ask the reproducibility-reviewer agent to
review the combined change, wait for the findings, and verify the final result.
State which checks ran and whether human review is still pending.
```

Subagents inherit the session's model. The reviewer can use only Read, Grep,
Glob, and Bash. That limits what it can do, but it is not a sandbox: Bash can
still write files. The attendee can use only Read, Grep, and Glob. It critiques
lessons and changes from a workshop participant's perspective. Its simulated
view does not replace feedback from real participants.

New or changed agent files load when Claude Code starts, so restart the session
before asking for a newly added agent.

## Hook behavior and boundaries

The hooks run the same script as the Codex setup. `SessionStart` adds the release
version, the locked R version, tool availability, and renv gaps to the session
context. `Stop` reports whitespace errors and R syntax errors in staged,
unstaged, and untracked R files as advisory `systemMessage` feedback. It never
blocks the session or makes Claude continue. A clean check prints nothing. See
[`.codex/README.md`](../.codex/README.md) for the full behavior.

`permissions.ask` prompts before `docker push` and `docker compose push`. Like
the Codex rules, these prefix matches miss other spellings, such as
`docker compose -f ... push` or Buildx `--push`. They do not prevent publishing.

## Verify the setup

```bash
python3 -m unittest discover -s .codex/tests -v
Rscript --vanilla .codex/scripts/check-r.R
echo '{}' | python3 .codex/hooks/project.py session-start
```
