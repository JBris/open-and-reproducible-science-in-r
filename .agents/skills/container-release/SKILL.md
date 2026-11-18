---
name: container-release
description: Build, review, or prepare releases for this project's Compose images, RStudio/Binder Dockerfiles, and GitHub Actions workflows.
---

# Workshop containers and releases

Read `AGENTS.md`, `AI_POLICY.md`, `VERSION`, both Compose files, the relevant
Dockerfiles, and the build workflows under `.github/workflows/`.

- Treat `VERSION` as the project release version. Compose does not load it
  automatically. Supply `APP_VERSION` explicitly for local commands:

  ```bash
  APP_VERSION="$(cat VERSION)" docker compose config --quiet
  APP_VERSION="$(cat VERSION)" docker compose build rstudio
  ```

- Check the image tag, build argument, versioned Dockerfile path, labels, and
  `binder/Dockerfile` parent tag together. A tag fallback to `latest` does not
  supply a missing build argument or versioned filename.
- Both build workflows read `VERSION` after checkout, validate a Docker-compatible
  release version, and export `APP_VERSION` using `$GITHUB_ENV`. Preserve the
  check that release tags match the version, allowing a leading `v`. Inspect
  `build.tags` before changing release/development tagging or publication.
- Compare the container R version with `renv.lock`. Confirm that every `COPY`
  source exists, including `renv/activate.R` for environment restoration. The
  current R and pipeline files are placeholders; their presence does not establish
  that the analysis exists. Do not invent bootstrap files to make a build pass.
- Preserve the dependency-builder/runtime separation. Runtime images need the
  lesson sources, `_quarto.yml`, styling, version/citation/licence metadata, and
  root community documents. `.github/` is excluded by `.dockerignore`, so policy
  pages must be copied from their root locations.
- Keep Rocker's `/init` startup for the RStudio service. Its `PASSWORD`, `ROOT`,
  and `DISABLE_AUTH` options are applied during that initialisation. With local
  authentication disabled, preserve the localhost port binding. Use the image's
  `rstudio` account consistently with the devcontainer.
- `binder/Dockerfile` uses the separately published Binder image. Preserve its
  Jupyter/Binder startup and non-root user. `rocker/binder` defaults to JupyterLab
  on port 8888 and provides RStudio through its proxy; direct RStudio startup uses
  `/init` as root and port 8787. `EXPOSE` alone neither starts nor publishes a service.
- Resolve Compose first, then build the affected image when its prerequisites
  are available. Check server startup when runtime behaviour changes. A resolved
  Compose file does not prove that an image builds or starts.

Prepare reviewable changes within the task's scope. Publish images or create
releases when the user's instructions cover that action. Report the tag, checks,
remaining prerequisites, and any pending human review under `AI_POLICY.md`.
