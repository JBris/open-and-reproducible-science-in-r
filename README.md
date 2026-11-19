# Open and Reproducible Science in R

[![R](https://img.shields.io/badge/R-4.4.1-blue)](https://www.r-project.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.24342489.svg)](https://doi.org/10.5281/zenodo.24342489)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/JBris/open-and-reproducible-science-in-r.git/HEAD)
[![Build RStudio](https://github.com/JBris/open-and-reproducible-science-in-r/actions/workflows/build-rstudio.yaml/badge.svg)](https://github.com/JBris/open-and-reproducible-science-in-r/actions/workflows/build-rstudio.yaml)
[![Build Binder](https://github.com/JBris/open-and-reproducible-science-in-r/actions/workflows/build-binder.yaml/badge.svg)](https://github.com/JBris/open-and-reproducible-science-in-r/actions/workflows/build-binder.yaml)

[**Documentation**](https://jbris.github.io/open-and-reproducible-science-in-r/)
| [**Changelog**](https://jbris.github.io/open-and-reproducible-science-in-r/CHANGELOG.html)
| [**Releases**](https://github.com/JBris/open-and-reproducible-science-in-r/releases)
| [**Docker configuration**](docker-compose.yaml)
| [**Binder**](https://mybinder.org/v2/gh/JBris/open-and-reproducible-science-in-r.git/HEAD)
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
correlations between health and well-being. We document and version the
dataset, run a correlation meta-analysis, and trace the result through
a report and an archive.

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

Set up your environment and verify the data before the session.
The draft teaching plan gives the timing and activities for each lesson.
[Preparation](pages/workshop/00_preparation.qmd) ·
[Draft teaching plan](draft/workshop_plan.qmd)

| Tools | Role in the core workflow |
| --- | --- |
| [Git](https://git-scm.com/) and [GitHub](https://github.com/) | Track changes, collaborate, and share code. |
| [renv](https://rstudio.github.io/renv/) and [Docker](https://www.docker.com/) | Record R dependencies and capture the computing environment. |
| [codebook](https://cran.r-project.org/package=codebook) and [dataspice](https://docs.ropensci.org/dataspice/) | Describe the variables and record FAIR dataset metadata. |
| [pins](https://pins.rstudio.com/articles/pins.html) | Store datasets with provenance and retrieve a specific version. |
| [targets](https://docs.ropensci.org/targets/) | Organise the analysis and track what needs to be rebuilt. |
| [Quarto](https://quarto.org/) | Connect the methods, results, and provenance in a report. |
| [Zenodo](https://zenodo.org/) | Archive permitted outputs and cite a specific release. |

By the end of the workshop, participants should be able to:

- Explain how the tools support different parts of a reproducible research workflow.
- Record dataset metadata and provenance and retrieve a specific version.
- Trace a result through the analytical pipeline and report.
- Identify the files and metadata needed for a citable archive.

Some familiarity with R will help participants follow the examples. The session
focuses on connecting the tools into a coherent workflow and understanding the
principles behind their use.

### Research objects and responsible sharing

The final five minutes include discussion and optional examples of
synthetic study summaries with `synthpop` and model versioning with
`vetiver`. Synthetic data can help others test a workflow. Verifying
findings based on original observations requires access to them, and
privacy claims need evidence about the mechanism and privacy accounting.
[Closing lesson](pages/workshop/09_extras_and_discussion.qmd)

## Usage with Docker

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

[Launch the workshop on Binder](https://mybinder.org/v2/gh/JBris/open-and-reproducible-science-in-r.git/HEAD).

Browser-based access through Binder is being prepared. The repository includes
a [Binder entry point](binder/Dockerfile) and a
[Binder image build workflow](.github/workflows/build-binder.yaml); the launch
configuration still needs to be completed and verified. Use the Docker option
once the workshop image is published.

## Render the book

The Quarto project produces an HTML book website and one PDF containing all
configured chapters. Install [Quarto](https://quarto.org/docs/get-started/),
R with `knitr` and `rmarkdown` for named R chunks, and a LaTeX distribution
such as TinyTeX. From the repository root, run:

```bash
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
chunks explicitly enable it. Rendering those chapters runs their examples,
including restoration, downloads, and analysis, or reuses cached results.
Use the prepared workshop environment. Workshop chapters execute from the
project root; the standalone report command specifies its own input directory.
The draft teaching plan is excluded from the book.

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

Contributors using Codex can refer to the [development setup](.codex/README.md)
and [project instructions](AGENTS.md) for repository skills, subagents, hooks,
and validation commands.

## Citation

If you use or adapt the workshop materials, please cite the workshop using the
metadata in [CITATION.cff](CITATION.cff).

## License

This workshop is published under the [MIT License](LICENSE).
