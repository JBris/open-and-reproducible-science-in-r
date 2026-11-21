---
name: r-reproducibility
description: Implement or review R code, renv dependencies, dataset/model provenance, and scientific reproducibility in this workshop project.
---

# R and reproducibility

Read `AGENTS.md`, `AI_POLICY.md`, the relevant R code, `.lintr`, and `renv.lock`.
This is a workshop project with no package `DESCRIPTION` or established R test
suite. `R/dummy.R` and `pipelines/_targets_dummy.R` are no-op placeholders;
the latter is not a runnable targets pipeline.

- Identify inputs, outputs, scientific assumptions, and expected behaviour
  before changing an analysis. Preserve raw observations and document filtering,
  missing-value handling, and statistical choices that affect interpretation.
- Use project-relative paths, explicit functions, and reproducible random seeds
  for ordinary stochastic examples. Avoid session-dependent objects, `setwd()`,
  and installing packages inside analysis or lesson code.
- For the pins/vetiver exercises, record dataset versions and explicit
  provenance links between data, models, code, parameters, and the software
  environment. Retrieve a specified version when a result depends on it.
- Use public teaching data in privacy demonstrations. Explain mechanism and
  accounting assumptions; a utility score, synthetic observations, or arbitrary
  noise is not a privacy guarantee. Review randomisation/seed handling separately
  from ordinary classroom reproducibility before claiming a private release.
- Follow local style and `.lintr`. Keep code readable for learners and reuse
  existing dependencies when practical.
- `.Rprofile` uses the committed renv 1.0.7 bootstrap, and the lockfile records
  the workshop packages. Inspect bootstrap files and the actual lockfile before
  relying on project startup.
  Restore or add dependencies when assigned and inspect resulting lockfile
  changes. Do not invent package records or initialise renv during unrelated work.
- Parse affected standalone scripts with
  `Rscript --vanilla .codex/scripts/check-r.R path/to/script.R`. This performs no
  evaluation. Validate inline Quarto chunks with the lesson workflow.
- For behaviour changes, run focused examples or existing tests in the restored
  environment. Check an edge case relevant to the analysis. Use `lintr` when
  available; do not install it silently as part of a syntax check.

Report the behaviour changed, actual validation evidence, environment limitations,
and pending human review. Keep release version changes and publication within
the requested scope.
