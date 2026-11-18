# Working in this repository

This repository contains the **Open and Reproducible Science in R** workshop,
published as a Quarto website. It is an R project, not an R package; do not add
package scaffolding or use `R CMD check` unless the task introduces a package.

## Project context

- `_quarto.yml` controls rendering, navigation, and the HTML/PDF formats.
  Code execution is disabled globally with `execute.eval: false`.
- `renv.lock` and the container base images currently specify R 4.4.1.
  The lockfile's package list is empty; inspect it before claiming dependencies
  are available.
- `.Rprofile` sources `renv/activate.R`. That bootstrap file may be absent in a
  fresh checkout. Report this accurately; do not silently initialize or replace
  the environment during unrelated work.
- `VERSION` is the project release version. Read it when supplying `APP_VERSION`
  to Compose. The image build workflows read this file and require release tags
  to match it, allowing a leading `v`. `.Rproj`'s `Version` is the project-file
  format version.
- `dockerfiles/rstudio/` and `dockerfiles/binder/` contain versioned Dockerfiles.
  `binder/Dockerfile` is the Binder repository entry point.
- `R/dummy.R` and `pipelines/_targets_dummy.R` contain no-op placeholders.
  They are not completed examples or a runnable targets pipeline.
- `pages/` contains reusable teaching material. Keep event names, dates, and
  venues in `ANNOUNCEMENTS.md`. `draft/3_workshop_plan.qmd` is an unpublished
  plan and is excluded from website rendering and navigation.
- `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, and `AI_POLICY.md`
  live at the repository root so Quarto can render them. GitHub workflow, issue,
  and PR templates retain their discovery locations under `.github/`.
- The RStudio Compose service uses Rocker's `/init`, with authentication disabled
  and port 8787 bound to localhost. Binder uses the separately built Binder image
  and its Jupyter/RStudio proxy startup, not the RStudio-only image.

## Working approach

Inspect the relevant files and `git status --short` before editing. Preserve
existing staged, unstaged, and untracked work. Implement the requested change,
run the smallest useful checks, and report the result and any checks that could
not run. Keep fixes to existing infrastructure separate from unrelated tasks.
For review-only requests, report findings without editing files. When a user
selects findings to fix, keep unselected findings outside the implementation.

Follow `AI_POLICY.md` when preparing contributions. Agents may perform assigned
development work; identify which checks actually ran and whether human review
is complete or pending. Agent verification is not human review.

Use Conventional Commits for Git commit messages: `type(scope): short summary`,
with the scope optional. Choose a type such as `feat`, `fix`, `docs`, `refactor`,
`test`, `ci`, `build`, or `chore`, and write a concise imperative summary.
For example: `fix(ci): read image version from VERSION`. Mark breaking changes
with `!` after the type/scope or a `BREAKING CHANGE:` footer when applicable.

Use project-relative paths and explicit inputs/outputs in R. Keep teaching
examples understandable to workshop participants. Make random examples
reproducible, preserve raw data, and explain substantive scientific assumptions.
Follow existing formatting and `.lintr`; avoid mass formatting during small edits.

The planned core includes dataset and model metadata/provenance with pins and
vetiver; differential privacy is a focused extension. Keep these planned
exercises distinct from the current placeholders. Use public teaching data and
do not infer a privacy guarantee from synthetic observations or utility scores.

Keep generated site output, caches, installed R libraries, and credentials out of
source changes. Install or snapshot dependencies when dependency work is part of
the task, and explain the resulting lockfile changes. Do not manually invent
`renv.lock` package records.

Keep `execute.eval: false` unless execution is part of the requested change.
Inspect a lesson's code before rendering it with execution enabled. A successful
render with evaluation disabled verifies the document, not the R example results.

## Validation

Run commands from the repository root:

```bash
# Parse maintained R scripts without running .Rprofile or executing the scripts.
Rscript --vanilla .codex/scripts/check-r.R

# Check specific edited files; quoted paths with spaces are supported.
Rscript --vanilla .codex/scripts/check-r.R path/to/script.R

# Resolve Compose configuration without building or starting containers.
APP_VERSION="$(cat VERSION)" docker compose config --quiet

# Check tracked edits for whitespace errors.
git diff --check
git diff --cached --check

# Verify the Codex hook behavior.
python3 -m unittest discover -s .codex/tests -v
```

Use `Rscript --vanilla` for dependency-free inspection when project startup is
unavailable. Use the restored project environment for behavior tests and linting.
Run existing tests affected by a change; add focused behavior tests for new R
logic where useful. There is currently no established R test suite.

For lesson edits, render the affected document as HTML with `quarto render
path/to/lesson.qmd --to html` when Quarto and its dependencies are available.
Render PDF only when the task affects PDF output. Missing tools or referenced
source files are limitations to report, not passing checks.

## Codex workflows

Repository skills live in `.agents/skills/`:

- `r-reproducibility`: R code, dependencies, and scientific reproducibility.
- `quarto-workshop`: lessons, navigation, and document validation.
- `container-release`: Compose, RStudio/Binder, and image versioning.

When parallel work is requested, use the custom agents in `.codex/agents/`:
`r_developer`, `lesson_editor`, and `reproducibility_reviewer`. Give each worker a
bounded task and explicit file ownership. Independent reviews can run in
parallel; coordinate shared-file edits. The main agent integrates the results
and verifies the final change. Use the same role guidance directly if the client
does not expose custom agents.

See `.codex/README.md` for configuration, hook trust, and invocation examples.
Hooks provide lightweight feedback; complete task-specific verification before
reporting success. Publishing images or releases should follow the user's task
authorization. Do not bump `VERSION` as a side effect of ordinary edits.
