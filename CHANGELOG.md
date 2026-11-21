# Changelog

## [Unreleased]

### Added

- Claude Code project instructions (`CLAUDE.md`), settings, subagents, lifecycle hooks, and image-publishing approval prompts alongside the existing Codex setup.
- Add partially completed `targets` pipeline and Quarto report templates in `pipelines/exercise/`. Participants copy them to an ignored `workspace/` folder, and lessons provide collapsed solutions and a pipeline catch-up step.
- Add `pipelines/prepare_health_wellbeing.R`, which prepares the versioned dataset inputs before the session and reuses matching versions when rerun.
- Add a hands-on lesson on modifying the analysis and reproducing the results.
- Add a supplementary `synthpop` exercise that pools the original and synthetic study summaries.
- Add an AIMOS2026 attendee subagent for Claude Code and Codex. It critiques workshop material from a participant's perspective without editing files.
- Record a simulated attendee review of the workshop revision in `draft/`. Record the outcome of the selected fixes in the review.
- Add prepared metadata for the HealthWellbeing snapshot and lock `rfair`
  and its dependencies.

### Changed

- Centre the FAIR lesson on dataset documentation with `dataspice` and
  assessment with `rfair`.
- Restructure the workshop into the final 90-minute programme, with one lesson per segment: 42 minutes of concepts and demonstrations, 40 minutes of hands-on exercises, and 8 minutes of discussion. Merge Git and GitHub into the conceptual opening and move hands-on Git practice to follow-up material.
- Demonstrate `vetiver` with a supplementary predictive model in the data and model versioning segment. Add GitHub releases to the archiving segment.
- Make MyBinder the single prepared participant environment, with no installation during the session.
- Add explicit recovery for participant work and isolate book rendering from that work.
- Teach selective rebuilding with an estimator change. Report heterogeneity, prediction intervals, and dataset and model provenance.
- Connect the vetiver demonstration to a predictive model branch and document the bundled snapshot's upstream MIT licence.
- Present the FAIR segment as a demonstration with a room question on access
  statements, introduce the pipeline as four stages, define confidence and
  prediction intervals before the report exercise, and start the archiving
  segment from the participant's report.
- Read the report's pipeline summary relative to the project root, so reports render from the project root without an execution-directory option.
- Revise the introduction, landing page, README, draft teaching plan, and page plan for the final programme.

## [0.5.0] - 2026-11-20

### Added

- Add a shared bibliography and a References chapter to the workshop book.
- Publish the full workshop PDF alongside the HTML book on GitHub Pages.

### Changed

- Make MyBinder the browser-based route for workshop participants, with a direct RStudio launch link and instructions for saving work.
- Explain Dockerfiles, Docker image builds, and the Binder and RStudio GitHub Actions workflows. Refresh the published HTML, PDF, search index, and sitemap with the revised lesson.

### Fixed

- Include the observed-versus-synthetic comparison plot in the published extras chapter. Allow generated figure assets under `docs/` to be tracked.

## [0.4.0] - 2026-11-20

### Added

- Include a checksum-verified copy of the `HealthWellbeing` teaching data.

### Changed

- Move `renv::restore()` into workshop setup so lesson renders use the prepared library.
- Reuse matching dataset pins across renders and record the configured pipeline script path when running targets with local `crew` workers.

### Fixed

- Restore executable rendering of the targets chapter with an interactive `visNetwork` graph in HTML and a text diagram in PDF. Pin `visNetwork` 2.1.4.
- Direct the published workshop homepage to the Introduction chapter.

## [0.3.0] - 2026-11-19

### Added

- Add the full 90-minute workshop sequence built around the `HealthWellbeing` teaching dataset. Cover Git and GitHub, renv and Docker, codebook and dataspice, pins, targets, Quarto, and Zenodo.
- Add a targets pipeline for correlation meta-analysis and a standalone Quarto report that records data versions, analysis settings, the Git revision, and software provenance.
- Include optional synthpop and vetiver examples in the closing discussion on responsible sharing.
- Document Quarto journal-format extensions with a PLOS example and describe automatic GitHub release archiving with Zenodo.

### Changed

- Expand the R 4.4.1 lockfile to 184 package records, configure local `crew` workers, and add system libraries for the workshop dependencies.
- Enable the workshop's R examples during rendering with explicit display and cache settings. Run them from the project root and preserve model versions across renders.

## [0.2.0] - 2026-11-19

### Added

- Add an attribution chapter and ORCID links for coordinators and acknowledged contributors.
- Publish the rendered HTML site, search index, sitemap, and bundled assets under `docs/`.
- Add reusable accessibility guidance and commit the renv 1.0.7 bootstrap.

### Changed

- Convert the workshop to a Quarto book with chapter navigation, a landing page, and configured HTML and PDF output.
- Install TinyTeX and common LuaLaTeX packages in reusable build layers. Prepare the renderer's font cache before copying project files and applying build labels.
- Point documentation links and site metadata to the GitHub Pages workshop site and link the Zenodo record.
- Allow GitHub release tags to differ from the image version in `VERSION`. Export a UTC `BUILD_DATE` for image labels.
- Mount the workshop checkout into the local RStudio service. Include the book's landing page and accessibility guidance in both runtime images.
- Expand the AI assistance policy.
- Refresh Codex guidance, agent roles, and skills for the current project structure and development policy.

## [0.1.0] - 2026-11-19

### Added

- Initial Quarto workshop website with introduction and coordinator pages.
- Workshop README covering learning objectives, setup, communication, and citation.
- R project configuration, an initial renv lockfile specifying R 4.4.1, and placeholder R and pipeline helpers.
- RStudio and Binder Dockerfiles, Docker Compose configuration, and GitHub Actions image build workflows.
- Local RStudio startup through Rocker's `/init` and a dedicated image for Binder launches.
- VS Code workspace settings, extension recommendations, and tasks for R syntax checks, Quarto, and Codex hook tests.
- Codex project instructions, skills, subagents, command rules, lifecycle hooks, and validation tools.
- AIMOS2026 workshop announcement with the session details, venue, presenters, and abstract.
- Contribution guidelines, community and security policies, citation metadata, and an MIT license.

### Changed

- Replaced earlier modelling workshop content with an integrated reproducibility workflow using GitHub, renv, Docker, targets, Quarto, and Zenodo.
- Generalised the workshop pages for reuse across events, with event-specific details in announcements.

[Unreleased]: https://github.com/JBris/open-and-reproducible-science-in-r/compare/v0.5.0...main
[0.5.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.5.0
[0.4.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.4.0
[0.3.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.3.0
[0.2.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.2.0
[0.1.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.1.0
