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

- [Introduction](#introduction)
- [Workshop](#workshop)
- [Usage with Docker](#usage-with-docker)
- [Usage with Binder](#usage-with-binder)
- [Coordinators](#coordinators)
- [Announcements](#announcements)
- [Communication](#communication)
- [Contributions and support](#contributions-and-support)
- [Citation](#citation)
- [License](#license)

## Introduction

Open and reproducible science helps research be understood, evaluated, reused,
and extended by others. This workshop introduces a practical workflow that
connects R with GitHub, renv, Docker, targets, Quarto, pins, vetiver, and Zenodo to
support reproducibility throughout the research lifecycle.

Participants will explore how these tools work together, from versioning code
and recording dependencies to organising analyses, versioning datasets and fitted
models, communicating results, and preserving research outputs. A focused
extension will explore differentially private synthetic data when original data
cannot be shared. The emphasis is on making research transparent, portable,
auditable, reusable, and accessible beyond the original researcher or computing
environment.

## Workshop

| Detail | Information |
| --- | --- |
| Conference | AIMOS2026 |
| When | Wednesday, 09:00–10:30 |
| Where | CO 119, Kelburn Campus, Victoria University of Wellington |
| Format | Workshop |

Read the [workshop materials](https://jbris.github.io/open-and-reproducible-science-in-r/pages/1_introduction.html)
on the [workshop website](https://jbris.github.io/open-and-reproducible-science-in-r/).
Quarto is used to organise the website and reports, with sources in the
[pages directory](pages/).

The [draft teaching plan](https://github.com/JBris/open-and-reproducible-science-in-r/blob/main/draft/3_workshop_plan.qmd) develops the expanded scope around
one prepared research project, with a two-hour format and a shorter 90-minute
adaptation. The practical examples and privacy demonstration remain under
development; the announced conference session details above are unchanged.

The core workflow will combine the following tools:

| Tool | Role in the workflow |
| --- | --- |
| [GitHub](https://github.com/) | Version control, collaboration, and open sharing of code and materials |
| [renv](https://rstudio.github.io/renv/) | Recording and restoring R package dependencies |
| [Docker](https://www.docker.com/) | Capturing the computational environment in a portable container |
| [targets](https://docs.ropensci.org/targets/) | Organising analysis steps and tracking which outputs need to be rebuilt |
| [pins](https://pins.rstudio.com/articles/pins.html) | Versioning datasets and recording metadata, hashes, and provenance links |
| [vetiver](https://vetiver.posit.co/get-started/version.html) | Versioning fitted models with input requirements and prediction dependencies |
| [Quarto](https://quarto.org/) | Connecting code, analysis, results, and narrative in reproducible reports |
| [Zenodo](https://zenodo.org/) | Archiving research outputs and assigning persistent identifiers |

By the end of the workshop, participants should be able to:

- Explain how the tools support different parts of a reproducible research workflow.
- Record dataset metadata and provenance, retrieve a specific dataset version, and link it to a fitted model.
- Develop a workflow that can be shared, reproduced, and archived.
- Explain the trade-offs between privacy and analytical utility when using synthetic data.
- Identify common barriers to reproducibility and practical strategies for addressing them.

Some familiarity with R will help participants follow the examples. The session
focuses on connecting the tools into a coherent workflow and understanding the
principles behind their use.

### Research objects and responsible sharing

The main practical activity will use `pins` for dataset versions and metadata,
with a short `vetiver` demonstration for fitted models. These records will link
data and model versions to the code, parameters, and environment used to produce
them. Local boards will have versioning enabled explicitly. A data dictionary
using [`codebook`](https://cran.r-project.org/package=codebook) is an optional extension.

The privacy extension will use public teaching data treated as restricted for
the exercise. `DPSynth` is a candidate for a synthetic-data demonstration, pending
review and testing of the chosen method and its privacy accounting; `diffpriv`
can support an explanation of underlying mechanisms. These are planned teaching
choices, not yet configured project dependencies. See the
[draft package and development plan](https://github.com/JBris/open-and-reproducible-science-in-r/blob/main/draft/3_workshop_plan.qmd).

Open science can include restricted-access data. Synthetic data can help others
run an analysis workflow, but does not establish that they can verify results
computed from inaccessible originals. Synthetic observations or arbitrary noise
also do not, by themselves, establish differential privacy. The extension will
consider the mechanism, privacy budget, repeated releases, and effects on
analytical utility. [NIST's overview](https://www.nist.gov/blogs/cybersecurity-insights/differentially-private-synthetic-data)
provides background on this distinction.

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
It does not mount a local project directory;
changes made inside the container remain in that container.

## Usage with Binder

[Launch the workshop on Binder](https://mybinder.org/v2/gh/JBris/open-and-reproducible-science-in-r.git/HEAD).

Browser-based access through Binder is being prepared. The repository includes
a [Binder entry point](binder/Dockerfile) and a
[Binder image build workflow](.github/workflows/build-binder.yaml); the launch
configuration still needs to be completed and verified. Use the Docker option
once the workshop image is published.

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
