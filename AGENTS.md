# Working in this repository

This repository contains the **Open and Reproducible Science in R** workshop,
published as a Quarto book with HTML website and PDF output. It is an R project,
not an R package; do not add package scaffolding or use `R CMD check` unless the
task introduces a package.

## Project context

- `_quarto.yml` defines the book chapters, navigation, and HTML/PDF formats.
  `index.qmd` is the landing chapter; generated output stays under `_site/`.
  Code execution is disabled globally with `execute.eval: false`.
- `renv.lock` and the container base images currently specify R 4.4.1.
  The lockfile records renv 1.0.7 and the workshop packages. Inspect it before
  claiming a dependency is available.
- `.Rprofile` sources the committed `renv/activate.R` bootstrap for renv 1.0.7.
  First startup can download/install renv. Use `Rscript --vanilla` for
  dependency-free checks; do not initialise or replace the environment during
  unrelated work.
- `VERSION` is the project release version. Read it when supplying `APP_VERSION`
  to Compose. Image workflows validate/export it and a UTC `BUILD_DATE`; GitHub
  release tags may differ from the image version. `.Rproj`'s `Version` is the
  project-file format version.
- `dockerfiles/rstudio/` and `dockerfiles/binder/` contain versioned Dockerfiles.
  `binder/Dockerfile` is the Binder repository entry point.
- `pipelines/_targets_health_wellbeing.R` and `pipelines/health_wellbeing_report.qmd`
  are the completed reference pipeline and report. `pipelines/exercise/` holds
  their partially completed participant templates, which lessons copy to the
  ignored `workspace/` folder. Keep the templates' numbered steps and TODOs
  aligned with the references.
- `pages/` contains reusable teaching material. Keep event names, dates, and
  venues in `ANNOUNCEMENTS.md`. `draft/workshop_plan.qmd` is an unpublished
  plan and is excluded from website rendering and navigation.
- `ANNOUNCEMENTS.md`, `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `ACCESSIBILITY.md`,
  `SECURITY.md`, `AI_POLICY.md`, and `CHANGELOG.md` live at the repository root
  so Quarto can render them. GitHub workflow, issue, and PR templates retain
  their discovery locations under `.github/`.
- Both images copy the project files participants need, including `data/raw/`,
  into `/home/rstudio`, the project root in MyBinder. That copy has no Git
  history; lessons must not assume a clone.
- The RStudio Compose service uses Rocker's `/init`, with authentication disabled
  and port 8787 bound to localhost. Binder uses the separately built Binder image
  and its Jupyter/RStudio proxy startup, not the RStudio-only image.
- TinyTeX installation, PDF packages, and the renderer user's font cache are
  prepared before runtime project copies. Keep volatile build arguments and
  labels after installation layers so timestamps do not invalidate those caches.

## Working approach

Inspect the relevant files and `git status --short` before editing. Preserve
existing staged, unstaged, and untracked work. Implement the requested change,
run the smallest useful checks, and report the result and any checks that could
not run. Keep fixes to existing infrastructure separate from unrelated tasks.
For review-only requests, report findings without editing files. When a user
selects findings to fix, keep unselected findings outside the implementation.

The maintainer has reviewed and accepted these known discrepancies. Do not
report them in content reviews unless the maintainer asks to revisit them:

- `CONTRIBUTING.md` keeps its template pull request process and its embedded
  Contributor Covenant 1.4, alongside the separate `CODE_OF_CONDUCT.md`.
- These instructions and the Quarto workshop skill describe rendered output
  under `_site/` and do not mention the committed GitHub Pages copy in `docs/`.
  `.vscode/settings.json` excludes `_site/`, but not `docs/`, from search.
- The instructions, skills, hook context, and setup READMEs call `VERSION`
  the release version. It is the image version, and GitHub release tags differ.
- `CITATION.cff` records version 1.0.0 and a release date of 2026-12-02.
- The pull request template has no field for AI-assistance disclosure or
  human review status.
- The draft page plan lists Git among the preparation tools.

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

The core covers dataset metadata and FAIR assessment with dataspice and rfair,
and data and model versioning with pins and vetiver. synthpop is a supplementary
exercise, and differential privacy is a possible future extension. Use public
teaching data and do not infer a privacy guarantee from synthetic observations
or utility scores.

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
For whole-book changes, use `quarto render --to all` to validate both formats.
Render PDF only when the task affects PDF output. Missing tools or referenced
source files are limitations to report, not passing checks.

## Codex and Claude Code workflows

Repository skills live in `.agents/skills/`:

- `r-reproducibility`: R code, dependencies, and scientific reproducibility.
- `quarto-workshop`: lessons, navigation, and document validation.
- `container-release`: Compose, RStudio/Binder, and image versioning.

When parallel work is requested, use the custom agents in `.codex/agents/`:
`r_developer`, `lesson_editor`, `reproducibility_reviewer`, and
`aimos2026_attendee`. Give each worker a bounded task and explicit file
ownership. Independent reviews can run in parallel; coordinate shared-file edits.
The main agent integrates the results and verifies the final change. Use the
same role guidance directly if the client does not expose custom agents.
`aimos2026_attendee` critiques material from a participant's perspective without
editing files; its simulated view does not replace real participant feedback.

Claude Code equivalents live in `.claude/agents/` (`r-developer`, `lesson-editor`,
`reproducibility-reviewer`, `aimos2026-attendee`) and `.claude/settings.json`,
which reuses the `.codex/` hook and R checker scripts.

See `.codex/README.md` and `.claude/README.md` for configuration, hook trust,
and invocation examples.
Hooks provide lightweight feedback; complete task-specific verification before
reporting success.

Before creating a GitHub release, update `CHANGELOG.md` and include the release
entry in the commit being tagged. Publishing images or releases should follow
the user's task authorization. Do not bump `VERSION` as a side effect of
ordinary edits.
