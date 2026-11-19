# Codex development setup

This setup supports the R/Quarto workshop using repository-scoped Codex features.
It was authored against Codex CLI 0.169.0. Use a current client; custom agents and
hooks have evolved across releases. Python 3.9+ is needed for the hook adapter;
Rscript is needed for syntax checks. The adapter uses the Python standard library
and the R checker uses base R, so neither installs additional packages.

## Files and responsibilities

| Location | Purpose |
| --- | --- |
| `AGENTS.md` | Project conventions, commands, and verification expectations |
| `AI_POLICY.md` | Human responsibility, AI assistance disclosure, and scientific verification |
| `.agents/skills/*/SKILL.md` | Reusable R, Quarto, and container workflows |
| `.codex/agents/*.toml` | R developer, lesson editor, and read-only reviewer |
| `.codex/config.toml` | Enable hooks and allow up to three concurrent subagents |
| `.codex/rules/release.rules` | Approval rules for direct Docker image publishing |
| `.codex/hooks.json` | SessionStart and Stop hook registration |
| `.codex/hooks/project.py` | Local lifecycle feedback without modifying source |
| `.codex/scripts/check-r.R` | Parse R scripts without evaluating them |
| `.codex/tests/test_hooks.py` | Hook behavior checks using temporary repositories |

## Start using it

Launch `codex` from this checkout. Codex loads project configuration for a trusted
repository. Review this project's hook definitions using `/hooks` and trust them
in your own client if you want them enabled. New or modified non-managed hooks
remain skipped until reviewed. Trust is a local user setting and is not recorded
by these project files.

Read the root [AI-assisted development policy](../AI_POLICY.md) when preparing
a contribution. Agents can carry out assigned local work and prepare drafts;
report their checks separately from human review. See `AGENTS.md` for the current
R version, placeholder status, and remaining environment prerequisites.

Skills are discoverable automatically. You can also invoke one explicitly:

```text
$r-reproducibility add a reproducible example for missing-value handling.
$quarto-workshop revise the introduction and check its HTML output.
$container-release review how VERSION reaches the Docker image tags.
```

To delegate, ask for named roles and bounded tasks:

```text
Use r_developer to implement the assigned helper in R/dummy.R and lesson_editor
to update its explanation in pages/1_introduction.qmd. Give each agent ownership
of its file. Then ask reproducibility_reviewer to review the combined change,
wait for the findings, and verify the final result. State which checks ran and
whether human review is still pending.
```

Agent definitions inherit the session's model and reasoning preferences. The
reviewer requests a read-only sandbox; live parent permission overrides still
apply. A client without custom-agent support can follow the same instructions
directly. No new MCP server, credential, or model subscription is required by
these files.

## Hook behavior and boundaries

`SessionStart` reports the release version, locked R version, executable
availability, and missing renv bootstrap or package records. It runs on startup,
resume, clear, and compaction. It does not restore dependencies.

`Stop` checks whitespace for staged and unstaged changes. It parses staged R
blobs from the Git index and checks unstaged and untracked R files on disk.
The R checks exclude renv and generated site directories. Feedback includes
pre-existing changes, remains advisory, and does not create continuation
loops. Clean checks are silent.
Untracked non-R files and inline R chunks are outside these hook checks.

The hooks do not execute R examples, render Quarto, build images, reformat files,
read chat transcripts, or publish anything. Run task-specific checks separately.
They resolve paths from the Git root, so launching Codex from a subdirectory is
supported. Commands target POSIX shells, including WSL and Linux containers;
native Windows hook commands would need a `commandWindows` adapter.

Command rules request approval for `docker push` and `docker compose push` when
run outside the sandbox. They do not inspect every spelling or wrapper, such as
`docker compose -f ... push` or Buildx `--push`, and are not a publication firewall.
They add no broad command allowances. Hosted CI publication uses the workflow's
permissions and is unaffected by local Codex execution rules.

## Verify or extend the setup

```bash
python3 -m unittest discover -s .codex/tests -v
Rscript --vanilla .codex/scripts/check-r.R
codex execpolicy check --pretty --rules .codex/rules/release.rules -- docker compose push rstudio
```

Keep stable project facts in `AGENTS.md`, reusable procedures in skills, agent
roles in TOML files, and deterministic lifecycle checks in hooks. Add concrete
behavior tests when extending hook logic. Keep model selection, credentials,
machine paths, and repository trust in user or managed configuration.

Keep the lesson pages reusable across events and the teaching plan under
`draft/` out of the rendered site. Root community documents are published pages;
GitHub workflows and issue/PR templates keep their locations under `.github/`.
For container changes, verify `/init` startup for RStudio, the Binder-specific
parent image, `VERSION` propagation, and the runtime project's copied files.

Official references: [project configuration](https://developers.openai.com/codex/config-advanced/),
[skills](https://developers.openai.com/codex/skills/),
[subagents](https://developers.openai.com/codex/subagents/),
[rules](https://developers.openai.com/codex/rules/), and
[hooks](https://learn.chatgpt.com/docs/hooks).
