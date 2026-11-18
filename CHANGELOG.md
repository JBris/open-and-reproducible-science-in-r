# Changelog

## [Unreleased]

### Added

- VS Code workspace settings, extension recommendations, and tasks for R syntax checks, Quarto, and Codex hook tests.
- An expanded teaching plan with two-hour and 90-minute formats built around one research project.
- No-op R and pipeline helper placeholders for the developing workshop project.

### Changed

- Point documentation links and website metadata to the GitHub Pages workshop site.
- Expanded the planned workshop scope to include dataset and model metadata, provenance, and versioning with pins and vetiver.
- Added a focused extension on differentially private synthetic data, privacy–utility trade-offs, and the limits of reproducing restricted-data findings.
- Read and validate VERSION in both image build workflows, including checks against release tags.
- Restore Rocker's RStudio initialisation and use the Binder-specific image for Binder launches.
- Include website configuration, styling, project metadata, and community documents in both runtime images.
- Move community documents to the repository root and rewrite the AI policy for this workshop.
- Refresh Codex guidance, agent roles, and skills for the current project structure and development policy.

## [0.1.0] - 2026-11-19

### Added

- Initial Quarto workshop website with introduction and coordinator pages.
- Workshop README covering learning objectives, setup, communication, and citation.
- R project configuration and an initial renv lockfile specifying R 4.4.2.
- RStudio and Binder Dockerfiles, Docker Compose configuration, and GitHub Actions image build workflows.
- Codex project instructions, skills, subagents, command rules, lifecycle hooks, and validation tools.
- AIMOS2026 workshop announcement with the session details, venue, presenters, and abstract.
- Contribution guidelines, community and security policies, citation metadata, and an MIT license.

### Changed

- Replaced earlier modelling workshop content with an integrated reproducibility workflow using GitHub, renv, Docker, targets, Quarto, and Zenodo.
- Generalised the workshop pages for reuse across events, with event-specific details in announcements.
