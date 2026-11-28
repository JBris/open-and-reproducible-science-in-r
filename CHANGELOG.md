# Changelog

## [1.0.0] - 2026-11-28

### Added

- Add the CARE Principles for Indigenous Data Governance to the FAIR lesson's
  further reading.
- Add a separate Docker Compose configuration for Memgraph, Memgraph Lab, and
  a read-only Memgraph MCP server.

### Changed

- Streamline MyBinder preparation and the opening Git exercise. Revise the
  lessons on computational environments, FAIR assessment, and data and model
  versioning to show the steps used in the workshop demonstrations.
- Revise the `targets`, Quarto, and reproduction exercises to clarify the
  dependency graph, report provenance, and comparison of REML and
  DerSimonian–Laird estimates.
- Configure RStudio to open the workshop project in the prepared environment
  when no project is active, and lock the `rstudioapi` dependency.
- Refresh the published HTML book, PDF, search index, and sitemap.

### Fixed

- Use Knitr for the lessons with Bash examples and skip interactive dependency
  graphs in PDF renders.
- Restore the CSS, JavaScript, and widget assets used by the published HTML.
- Repair the links to the Correlations section and dataset preparation. Remove
  links to the retired export checklist and Git fork exercise.

## [0.9.0] - 2026-11-22

### Changed

- Recommend the Claude Code extension alongside the Codex extension in the
  VS Code workspace, and label the hook-test task for both.
- Record the maintainer-accepted discrepancies in `AGENTS.md` so agent reviews
  do not report them again.
- Remove the redirect pages for chapter addresses used before the `0.6.0`
  restructure, so `pages/` holds only lesson sources.
- Remove the `CRANextra` repository from `renv.lock`. No locked package comes
  from it, and renv's check of that server could stall R sessions, including
  book renders.
- Rebuild the published HTML book and PDF.

### Fixed

- Show the Massey University contact on the published contribution page.
- Make clear that the opening Git activity compares the reference pipeline,
  the completed solution to the pipeline exercise.
- Show the release image workflow status in the README so the badge covers
  both the RStudio and Binder builds.
- Include the project-root `.here` file in the export checklist and link to
  the step that saves `fair-assessment.rds` before export.
- Explain that versioned pins keep previous versions and skip identical
  writes by default.

## [0.8.0] - 2026-11-22

### Changed

- Describe the workshop archive through its concept DOI, which cites all
  versions and resolves to the latest one, in the opening, the archiving
  checkpoint, the README, and the draft plans.
- Remove the unused `R/dummy.R` and `pipelines/_targets_dummy.R`
  placeholders, their mentions in the agent instructions, and the `R/` copy
  in both images.
- Write the FAIR lesson's follow-up on saving assessment results for
  participants. It explains why to keep the run date and versions, and where
  to find and export the saved file.
- List every root document rendered into the book in the agent instructions
  and the Quarto workshop skill.
- Refresh the published FAIR lesson and PDF.

### Fixed

- Direct participants with a missing report to Step 1 of the Quarto
  exercise, because recovery no longer restores the report.
- Mention the opening Git activity in the session overview. Drop the
  retrieval date from the notes for the commit-pinned teaching snapshot.
- Update the simulated review record and the draft plan's checklist to
  match the changes made since.
- Use the coordinator's Massey University address for conduct reports in the
  contribution guidelines.
- Align the draft plan's FAIR learning objective with the introduction and
  README.

## [0.7.0] - 2026-11-22

### Changed

- On GitHub releases, build and push the RStudio image before building
  the Binder image from the same revision.
- Use FAIR for Research Software metrics when assessing the workshop's
  Zenodo record in the archiving follow-up.

### Fixed

- Restore the full 29-study REML baseline during recovery and preserve
  participants' report edits so they can complete the Quarto exercise.
- Keep former workshop URLs and their section links working. Restore
  the homepage search links for Getting started and People and community.
- Link the README directly to the published preparation and Quarto
  exercises. Explain which `.Rproj` to open in a local Docker session.
- Document the `.here` marker and summary CSV path needed to rerender
  an unpacked report.
- Pin the JSON-LD revision used by the FAIR assessment and link the
  workshop archive through its concept DOI.

## [0.6.0] - 2026-11-21

### Added

- Claude Code project instructions (`CLAUDE.md`), settings, subagents, lifecycle hooks, and image-publishing approval prompts alongside the existing Codex setup.
- Add partially completed `targets` pipeline and Quarto report templates in `pipelines/exercise/`. Participants copy them to an ignored `workspace/` folder, and lessons provide collapsed solutions and a recovery script.
- Add `pipelines/prepare_health_wellbeing.R`, which prepares the versioned dataset inputs before the session and reuses matching versions when rerun.
- Add a hands-on lesson on modifying the analysis and reproducing the results.
- Add a supplementary `synthpop` exercise that pools the original and synthetic study summaries.
- Add an AIMOS2026 attendee subagent for Claude Code and Codex. It critiques workshop material from a participant's perspective without editing files.
- Record a simulated attendee review of the workshop revision in `draft/`. Record the outcome of the selected fixes in the review.
- Add prepared metadata and a reviewed JSON-LD record for the
  `HealthWellbeing` snapshot. Show the full record in the FAIR lesson and
  lock `rfair` and its dependencies.

### Changed

- Centre the FAIR lesson on dataset documentation with `dataspice` and
  assessment with `rfair`.
- Restructure the workshop into the final 90-minute programme, with one lesson per segment: 40 minutes of concepts and demonstrations, 42 minutes of hands-on work, and 8 minutes of discussion. Merge Git and GitHub into the opening and move the fork, commit, and push practice to follow-up material.
- Demonstrate `vetiver` with a supplementary predictive model in the data and model versioning segment. Add GitHub releases to the archiving segment.
- Make MyBinder the single prepared participant environment, with no installation during the session.
- Add explicit recovery for participant work and isolate book rendering from that work.
- Teach selective rebuilding with an estimator change. Report heterogeneity, prediction intervals, and dataset and model provenance.
- Connect the vetiver demonstration to a predictive model branch and document the bundled snapshot's upstream MIT licence.
- Present the FAIR segment as a demonstration that runs `rfair` live against
  the repository's JSON-LD, served through jsDelivr, with a room question on
  access statements, introduce the pipeline as four stages, define confidence and
  prediction intervals before the report exercise, and start the archiving
  segment from the participant's report.
- Add a two-minute Git activity to the opening, in which participants read
  the public repository's tags and history in MyBinder without cloning it.
  Participants now use the project already in their MyBinder session.
- Remove 11 packages left in `renv.lock` after `codebook` was dropped
  (`GPArotation`, `gridExtra`, `haven`, `labelled`, `likert`, `mnormt`,
  `psych`, `repr`, `reshape2`, `rmdpartials`, and `skimr`), so
  `renv::status()` reports a consistent project.
- Copy `data/raw/` into the RStudio and Binder images, so MyBinder sessions
  include the teaching snapshot and its licence notice, and the recovery
  script works in a fresh session.
- Align lesson titles, objectives, recovery wording, and the coordinator
  affiliation with the current programme, and update the agent instructions
  for the implemented exercises and the MyBinder copy without Git history.
- Read the report's pipeline summary relative to the project root, so reports render from the project root without an execution-directory option.
- Revise the introduction, landing page, README, draft teaching plan, and page plan for the final programme.
- Refresh the published HTML book and PDF for the revised programme.

## [0.5.1] - 2026-11-20

### Changed

- Backfill the workshop release history through `v0.5.0` and publish the
  changelog in the HTML book and PDF.

### Fixed

- Render the targets and vetiver examples in MyBinder without a Git
  checkout. Keep the dataset version, pipeline checksum, and software
  versions in the analysis report.

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

[Unreleased]: https://github.com/JBris/open-and-reproducible-science-in-r/compare/v1.0.0...main
[1.0.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v1.0.0
[0.9.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.9.0
[0.8.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.8.0
[0.7.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.7.0
[0.6.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.6.0
[0.5.1]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.5.1
[0.5.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.5.0
[0.4.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.4.0
[0.3.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.3.0
[0.2.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.2.0
[0.1.0]: https://github.com/JBris/open-and-reproducible-science-in-r/releases/tag/v0.1.0
