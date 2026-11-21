# Open and Reproducible Science in R

[![R](https://img.shields.io/badge/R-4.4.1-blue)](https://www.r-project.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.24342489.svg)](https://doi.org/10.5281/zenodo.24342489)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/JBris/open-and-reproducible-science-in-r/HEAD?urlpath=rstudio)
[![Build RStudio](https://github.com/JBris/open-and-reproducible-science-in-r/actions/workflows/build-rstudio.yaml/badge.svg)](https://github.com/JBris/open-and-reproducible-science-in-r/actions/workflows/build-rstudio.yaml)
[![Build Binder](https://github.com/JBris/open-and-reproducible-science-in-r/actions/workflows/build-binder.yaml/badge.svg)](https://github.com/JBris/open-and-reproducible-science-in-r/actions/workflows/build-binder.yaml)

[**Documentation**](https://jbris.github.io/open-and-reproducible-science-in-r/)
| [**Changelog**](https://jbris.github.io/open-and-reproducible-science-in-r/CHANGELOG.html)
| [**Releases**](https://github.com/JBris/open-and-reproducible-science-in-r/releases)
| [**Docker configuration**](docker-compose.yaml)
| [**Open RStudio on MyBinder**](https://mybinder.org/v2/gh/JBris/open-and-reproducible-science-in-r/HEAD?urlpath=rstudio)
| [**Citation**](CITATION.cff)

*A practical workshop on building open and reproducible research workflows with R and open-source tools.*

## Table of contents

- [Open and Reproducible Science in R](#open-and-reproducible-science-in-r)
  - [Table of contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Workshop](#workshop)
    - [Research objects and responsible sharing](#research-objects-and-responsible-sharing)
  - [Usage with Docker](#usage-with-docker)
  - [Usage with Binder](#usage-with-binder)
  - [Render the book](#render-the-book)
  - [Coordinators](#coordinators)
  - [Announcements](#announcements)
  - [Communication](#communication)
  - [Contributions and support](#contributions-and-support)
  - [Citation](#citation)
  - [License](#license)

## Introduction

Open and reproducible science helps research be understood, evaluated, reused,
and extended by others. This 90-minute workshop follows one prepared R
project using `HealthWellbeing`, a teaching dataset of published
correlations between health and well-being. Participants see how the
dataset is documented and versioned, then complete and run a
correlation meta-analysis pipeline, render a report from its outputs,
and change the analysis to reproduce the results. The aim is to
understand and experience an end-to-end reproducible research workflow,
not to master every package.

## Workshop

| Detail     | Information                                               |
| ---------- | --------------------------------------------------------- |
| Conference | AIMOS2026                                                 |
| When       | Wednesday, 09:00–10:30                                    |
| Where      | CO 119, Kelburn Campus, Victoria University of Wellington |
| Format     | Workshop                                                  |

Read the [workshop materials](https://jbris.github.io/open-and-reproducible-science-in-r/pages/1_introduction.html)
on the [workshop website](https://jbris.github.io/open-and-reproducible-science-in-r/).
Quarto is used to organise the website and reports, with sources in the
[pages directory](pages/).

Open the prepared MyBinder environment, verify the data, and prepare the
dataset versions before the session. The
[programme](https://jbris.github.io/open-and-reproducible-science-in-r/pages/1_introduction.html#intro-programme)
lists the timing and format of each segment, and the draft teaching plan
describes how they are delivered.
[Preparation](pages/workshop/00_preparation.qmd) ·
[Draft teaching plan](draft/workshop_plan.qmd)

| Tools | Role in the core workflow |
| --- | --- |
| [Git](https://git-scm.com/) and [GitHub](https://github.com/) | Track changes, collaborate, and share code. |
| [renv](https://rstudio.github.io/renv/), [Docker](https://www.docker.com/), and [Binder](https://mybinder.org/) | Record R dependencies, capture the computing environment, and provide it in a browser. |
| [dataspice](https://docs.ropensci.org/dataspice/) and [rfair](https://cran.r-project.org/package=rfair) | Create structured metadata and assess what software can discover about a dataset. |
| [pins](https://pins.rstudio.com/articles/pins.html) and [vetiver](https://vetiver.posit.co/) | Store data and model versions with provenance and retrieve a specific version. |
| [targets](https://docs.ropensci.org/targets/) | Organise the analysis and track what needs to be rebuilt. |
| [Quarto](https://quarto.org/) | Connect the methods, results, and provenance in a report. |
| GitHub releases and [Zenodo](https://zenodo.org/) | Release, archive, and cite a specific version. |

By the end of the workshop, participants should be able to:

- Explain how the tools support different parts of a reproducible research workflow.
- Explain how metadata and data and model versions support provenance.
- Complete and run a `targets` pipeline and render a Quarto report from its outputs.
- Modify an analysis input, rebuild only what is affected, and reproduce the result.
- Identify the files and metadata needed for a citable release and archive.

The session combines 42 minutes of concepts and demonstrations, 40 minutes of
hands-on exercises, and 8 minutes of discussion. Participants complete a
partially prepared pipeline and report in one prepared MyBinder environment,
so nothing is installed during the session. Some familiarity with R will help
participants follow the examples.

### Research objects and responsible sharing

A branch of the pipeline trains and pins a small regression with `vetiver`
using the same checked data as the meta-analysis. The report records its
model version.
Synthetic study summaries with `synthpop` are a supplementary exercise, mentioned
briefly in the archiving segment. Synthetic data can help others test a
workflow. Verifying findings based on original observations requires access to
them, and privacy claims need evidence about the mechanism and privacy
accounting.
[Data and model versioning](pages/workshop/04_versioning.qmd) ·
[Supplementary synthetic data exercise](pages/workshop/10_synthetic_data.qmd)

## Usage with Docker

Workshop participants can use [MyBinder](#usage-with-binder) from a browser.
Use this section if you want to run the workshop image locally with Docker.

The [Compose configuration](docker-compose.yaml) provides an RStudio service for
working with the workshop environment. Install Docker with the Docker Compose
plugin, then run the following commands in a terminal to use a published image:

```bash
git clone https://github.com/JBris/open-and-reproducible-science-in-r.git
cd open-and-reproducible-science-in-r

export APP_VERSION="$(cat VERSION)"
docker compose pull rstudio
docker compose up --no-build rstudio
```

The image matching [VERSION](VERSION) must be published to the GitHub Container
Registry before it can be pulled. Loading `APP_VERSION` explicitly selects the
workshop release recorded in the repository.

Open [RStudio at localhost:8787](http://localhost:8787) in your browser. Press
**Ctrl+C** in the terminal to stop the service.

The supplied configuration uses Rocker's `/init` startup, disables RStudio
authentication, and binds port 8787 to localhost for local workshop use.
The local repository is mounted at `/home/rstudio/open-reproducible-science-r`.
Save workshop changes in that directory to keep them in your local checkout.

## Usage with Binder

[Open RStudio on MyBinder](https://mybinder.org/v2/gh/JBris/open-and-reproducible-science-in-r/HEAD?urlpath=rstudio)
and follow the [workshop preparation steps](pages/workshop/00_preparation.qmd#choose-your-computing-environment).
Allow time to start the session and download your work before it ends.

The [Build Binder workflow](.github/workflows/build-binder.yaml) builds and
publishes the image selected by the [Binder entry point](binder/Dockerfile).
The [Build RStudio workflow](.github/workflows/build-rstudio.yaml) publishes the
image for local Docker use.

Before teaching the [FAIR lesson](pages/workshop/03_data_documentation.qmd),
check that the Binder image has the `rfair` version in `renv.lock`.
Prepare the two assessment results in advance so the demonstration can use
them if an upstream request times out.

## Render the book

The Quarto project produces an HTML book website and one PDF containing all
configured chapters. Use R 4.4.1, [Quarto](https://quarto.org/docs/get-started/),
and a LaTeX distribution such as TinyTeX. From the repository root, run:

```bash
# Restore the workshop library before the first render and after lockfile changes.
Rscript -e 'renv::restore()'

# Install TinyTeX if a LaTeX distribution is not already available.
quarto install tinytex

# Build both configured formats.
quarto render --to all
```

The HTML home page is `_site/index.html`; the PDF is
`_site/open-and-reproducible-science-in-r.pdf`. The HTML navigation includes a
PDF download. To build a single format, use `quarto render --to html` or
`quarto render --to pdf`. Preview the HTML book with `quarto preview --to html`.

Code evaluation is disabled by default in `_quarto.yml`, but workshop R
example chunks explicitly enable it. Rendering uses the restored library
and runs the examples. The book uses the reference pipeline and writes its
generated analysis files under `outputs/health-wellbeing/book/`.
Participant commands use `workspace/` and `outputs/health-wellbeing/`.
From the project root, use `source("pipelines/recover_workshop.R")` to
prepare missing inputs, back up working copies, and load the reference
exercise files. The standalone report renders from the project root and
locates the summary relative to that root. Draft teaching plans are
excluded from the book.

## Coordinators

- **James Bristow**, Massey University — presenter and coordinator
  ([J.Bristow2@massey.ac.nz](mailto:J.Bristow2@massey.ac.nz)).
- **Hana Liang**, Bioeconomy Science Institute — co-author.

## Announcements

See the [workshop announcements](https://jbris.github.io/open-and-reproducible-science-in-r/ANNOUNCEMENTS.html)
for updates.

## Communication

- Use [GitHub Discussions](https://github.com/JBris/open-and-reproducible-science-in-r/discussions)
  for workshop questions and discussion.
- Use [GitHub Issues](https://github.com/JBris/open-and-reproducible-science-in-r/issues)
  for bug reports, documentation improvements, and feature requests.

## Contributions and support

Contributions to the workshop materials, examples, and documentation are welcome.
See the [contribution guidelines](https://jbris.github.io/open-and-reproducible-science-in-r/CONTRIBUTING.html),
[community code of conduct](https://jbris.github.io/open-and-reproducible-science-in-r/CODE_OF_CONDUCT.html), and
[AI-assisted development policy](https://jbris.github.io/open-and-reproducible-science-in-r/AI_POLICY.html).

Contributors using Codex or Claude Code can refer to the development setup for
[Codex](.codex/README.md) or [Claude Code](.claude/README.md)
and [project instructions](AGENTS.md) for repository skills, subagents, hooks,
and validation commands.

## Citation

If you use or adapt the workshop materials, please cite the workshop using the
metadata in [CITATION.cff](CITATION.cff).

## License

This workshop is published under the [MIT License](LICENSE).
