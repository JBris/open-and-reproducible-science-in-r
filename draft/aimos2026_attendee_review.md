# Simulated attendee review of the workshop revision

| Detail | Information |
| --- | --- |
| Reviewed | `workshop-revision.diff`, the revision in `ef8b138` against `8b88f32`. The file has since been removed; read it with `git show ef8b138:workshop-revision.diff`. |
| Reviewer | The `aimos2026-attendee` subagent in Claude Code (Claude Opus 5.5) |
| Date | 2026-11-21 |
| Status | Findings recorded only. No material was changed in response. |

An AI subagent produced this review while role-playing an attendee of the
AIMOS2026 workshop. It read the materials but could not launch MyBinder, run
code, or see rendered pages. It is not feedback from real participants, and it
is not human review. Sections 1 to 5 are the subagent's report, unedited. The
final section records evidence from the revision that the reviewer could not
see.

## 1. Overall impression

As a typical attendee, I would come away with a clear picture of how the tools fit together. The middle of the session is well designed and genuinely hands-on: I complete a pipeline, render a report from it, then change the input. Each page says how long to spend, where to type, and which number I should see. But the whole session depends on a MyBinder path that the revision itself lists as untested. The recovery routes cover unfinished TODOs, not a late arrival or a lost session. The main thing targets is known for, rebuilding only what changed, appears only in an optional step. A meta-research audience will notice that a random-effects meta-analysis is reported with no heterogeneity statistic. They will also notice that the end-to-end chain stops before release: nothing an attendee produces is tracked by Git or could go into the archive described in the closing segment.

Scope and limits: I read `ANNOUNCEMENTS.md`, `pages/1_introduction.qmd`, every lesson in `pages/workshop/`, the exercise templates and reference files in `pipelines/`, `_quarto.yml`, `.gitignore`, the Binder Dockerfiles, `draft/workshop_plan.qmd`, and the summary and hunks of `workshop-revision.diff`. I could not launch MyBinder, run code, or see rendered pages. Every number below is the value the materials expect, not output I verified.

### Segment walk-through

| Segment | What to do, why, success | Feasible in time? | Main concern |
| --- | --- | --- | --- |
| Preparation | Clear steps and checkpoint | Yes, if Binder starts promptly | It must be done in the same session used for the workshop (M1) |
| 0–10 Introduction, Git | Clear, well-argued "why" | Yes | "push" appears in the checkpoint but is never defined (m2) |
| 10–20 Environments | Clear why; the Docker part is heavy on jargon | Tight | Build infrastructure, not how to apply it to my own project (M5, M6) |
| 20–28 Metadata | Clear what; success ends at `TRUE` | Yes (demonstration) | The metadata is never shown; the licence is left blank (M7, m6) |
| 28–35 Versioning | pins connects to the pipeline | Tight | vetiver connects to nothing later (M6) |
| 35–50 targets | The best-designed segment | Tight but feasible | Recovery depends on Step 1 (M1) |
| 50–65 Quarto | Clear | Feasible | The render command was not verified (B1); a leftover TODO marker (m1) |
| 65–75 Modify | Clear | Very tight: three full rebuilds and two or three renders | Selective rebuilding is optional (M2) |
| 75–82 Archiving | Clear concepts | Yes | Not connected to anything built in the session (M4) |
| 82–90 Discussion | Good prompts | Yes | The export instruction leaves out the outputs (m7) |

### How the experience differs for other attendees

- **Someone with little R experience** meets `box::use()`, `crew`, `loadNamespace("visNetwork")`, a bash `if` block, and inline `sprintf("%.0f%%", ...)` without explanation (m2). They also switch between the Terminal and the Console in every hands-on segment (m5). The collapsed solutions and the pipeline catch-up step will carry them through `05`. The report has no catch-up step, so a broken YAML header or inline expression in `06` could strand them (M1). REML and Hartung–Knapp are named but not explained (`05_targets.qmd:45-47`), although the preparation page says "you do not need previous experience with meta-analysis" (`00_preparation.qmd:14-15`).
- **A data steward or librarian** gets 15 minutes of demonstration and concepts that matter to them (`03`, `08`). The metadata demonstration ends with `file.exists(...)` returning `TRUE`, and the JSON-LD is never displayed (m6). The licence field is left blank, and the basis for redistributing the raw file is never stated (M7). The metadata files are written to a folder Git ignores, so they could not be part of the release the archiving segment describes (M4). The report identifies its data by a pin version that the material itself calls board-local (M4). This attendee would get the most from the after-workshop Zenodo steps (`08_archiving.qmd:119-134`) and the archive checklist (`08_archiving.qmd:73-79`).

## 2. What works well

- **Every hands-on step has a time, a place, and an expected result.** Examples: "Allow about four minutes. Edit `workspace/_targets.R` and save it." (`05_targets.qmd:112`). The checkpoint in `06_quarto.qmd:140-144` gives exact values: "29 studies, a pooled correlation of 0.363, and a 95% interval from 0.309 to 0.415". I always know what success looks like.
- **Running the unfinished pipeline first is a strong design.** Step 2 runs the incomplete pipeline and tells me to expect a failure: "The run stops with the message `Complete TODO 1 in the fit target.`" (`05_targets.qmd:105-106`). Because the error is expected and names the TODO, an error message becomes part of the lesson. TODO 1 then teaches the central idea of targets: "Mentioning `studies` makes `fit` depend on it" (`05_targets.qmd:127-128`).
- **Copies and catch-up steps protect attendees' work.** The copy commands run "only if it does not exist yet, so rerunning the chunk keeps your edits" (`05_targets.qmd:60-61`, `06_quarto.qmd:31-32`). The catch-up step leaves a completed copy unchanged (`05_targets.qmd:143-145`).
- **The pipeline reads a named data version, not the newest.** It reads "the version named in `analysis-data-version.txt` rather than whichever version is newest" (`04_versioning.qmd:85-86`). This links pins to the hands-on work and is a point many researchers have not met.
- **The caveats would satisfy a meta-research audience.** "Reproducibility does not establish that the scientific assumptions are correct" (`01_open_science.qmd:24-25`). "A pooled association alone does not establish a causal effect" (`01_open_science.qmd:54`). "using them does not by itself establish that a dataset meets every FAIR principle" (`03_data_documentation.qmd:192-193`). "A close match would not verify the original finding, and a difference would not refute it" (`10_synthetic_data.qmd:136-138`). Step 1 of the modify segment limits its claim to "in this environment" (`07_modify_and_reproduce.qmd:56-58`).
- **Preparation is proportionate.** It needs one link, three Terminal commands and three Console chunks, with a four-item checkpoint (`00_preparation.qmd:169-177`). Shipping the raw file with the repository removes a download that could fail (`00_preparation.qmd:28-30`).
- **The order of the programme gives late arrivals time to catch up.** Thirty-five minutes of demonstrations come before any hands-on step, so someone who arrives late can finish setup before minute 35. The materials do not yet say this (see M1).
- **Some accessibility measures are already in place.** A text dependency diagram is given alongside the interactive graph (`05_targets.qmd:33-36`). Inline R syntax is described in words rather than only shown: "a backtick, the letter `r`, an expression, and a closing backtick" (`06_quarto.qmd:59-61`).
- **There are clear ways to continue afterwards.** After-workshop sections cover Git with a fork, Quarto journal formats, and Zenodo integration (`09_discussion.qmd:60-68`).

## 3. Problems ranked by impact

### Blocker

#### B1. The single environment and the hands-on path have not been tested in MyBinder

- **Evidence.**
  - The revision summary lists as pending "a timed rehearsal, and a test in a fresh MyBinder launch" (`workshop-revision.diff:117-118`). The plan still has an unticked item: "confirm that a fresh MyBinder session runs every hands-on step" (`draft/workshop_plan.qmd:246-248`).
  - The checks that did run used `ghcr.io/jbris/open-reproducible-science-r:1.0.0` (`workshop-revision.diff:103-104`). MyBinder launches a different image, `ghcr.io/jbris/binder-open-reproducible-science-r:1.0.0` (`binder/Dockerfile:1`).
  - The participant command `quarto render workspace/report.qmd --to html` (`06_quarto.qmd:39`, `07_modify_and_reproduce.qmd:95`) is not among the listed checks, and the book render never runs it.
  - That file sits inside a book project whose `_quarto.yml` sets `execute: eval: false` and `output-dir: _site` and has a `render:` list that excludes `workspace/` (`_quarto.yml:1-21`, `_quarto.yml:106-107`). Only a real run can confirm that `workspace/report.html` is produced, where the page says it will be (`06_quarto.qmd:46-48`), and that the report's chunks are evaluated.
  - "Everyone uses the same prepared environment" (`00_preparation.qmd:35`). The only fallback is "a prepared alternative" (`00_preparation.qmd:50-51`), which is not described.
- **What an attendee would experience.** I cannot say whether anything fails. If the Binder launch, `renv::status()`, the crew worker, or the report render misbehaves in MyBinder, it fails for every attendee at once. All 40 minutes of hands-on work and the "experience" half of the main outcome would go with it. This is a readiness blocker, not an observed failure.
- **Suggested change.** Before the session, run every participant step in a fresh MyBinder launch, timed, with several people launching at the same time. Include the Terminal render, RStudio's **Render** button, and a 35-minute idle period. Record the result in the plan. Name the fallback concretely, for example the RStudio Docker image or a second Binder link.

### Major

#### M1. Recovery covers unfinished TODOs, not late arrivals or lost sessions

- **Evidence.**
  - The preparation page frames setup as happening "Before the timed session" (`00_preparation.qmd:9`). It also warns that "files in a session are lost when it ends" (`00_preparation.qmd:46-48`) and that "MyBinder stops idle sessions" (`00_preparation.qmd:41-42`). It never says that preparation must be done on the day, in the session the attendee will use.
  - The Quarto page tells late joiners to "run the targets activity's catch-up step and `tar_make()` first" (`06_quarto.qmd:22-24`). The catch-up chunk calls `readLines(pipeline_script)` (`05_targets.qmd:148`), but `pipeline_script`, the copied file, and the `tar_make` import all come from Step 1 (`05_targets.qmd:66-81`). Run as instructed, it fails with "object 'pipeline_script' not found".
  - If the report breaks, the only help is "compare your copy with it" (`06_quarto.qmd:115-117`). There is no command to restore the reference report and no guidance on reading a Quarto render error.
  - The setup guard `stopifnot(file.exists(pipeline_script), file.exists(summary_path))` (`07_modify_and_reproduce.qmd:43`) fails with an error that does not say what to do next.
- **What an attendee would experience.** Someone who arrives at 09:05, loses their session during the demonstrations, or breaks the report would spend the hands-on half rebuilding state from instructions spread across four pages while the room moves on.
- **Suggested change.**
  - At the top of `05`, `06` and `07`, add one "Get back on track" callout with a chunk that is safe to rerun. It should:
    - source the preparation script if `analysis-data-version.txt` is missing
    - create `workspace/`
    - copy the reference pipeline while TODOs remain
    - run `tar_make()`
    - copy the reference report if `workspace/report.qmd` is absent.
  - In `00`, say that preparation must be done on the morning, in the session you will use.
  - In `01`, tell late arrivals they can finish setup during the demonstrations.

#### M2. "Rebuild only what is affected" happens only in an optional step

- **Evidence.**
  - The learning objective is "Modify an analysis input, rebuild only what is affected, and reproduce the result" (`pages/1_introduction.qmd:35`).
  - In the core path, Step 1 invalidates everything (`07_modify_and_reproduce.qmd:48`). Step 2 states: "Every target is outdated" (`07_modify_and_reproduce.qmd:79-80`). Step 4 reruns everything again (`07_modify_and_reproduce.qmd:119-120`).
  - The only partial rebuild is under "Optional: change a method instead" (`07_modify_and_reproduce.qmd:123-136`). The only other demonstration of skipping is the all-skipped rerun (`05_targets.qmd:194-195`).
- **What an attendee would experience.** In 10 minutes, with three full rebuilds and two or three renders, almost nobody will reach the optional step. I would leave having seen targets rebuild everything or nothing, and would not have seen the behaviour that justifies using it.
- **Suggested change.** Make the method change (`REML` to `DL`, which rebuilds only `fit`, `result` and `summary_file`) the core Step 2. Move the data switch into the optional step. Alternatively, drop the separate restore step: rendering against the subset and then switching back is not needed to meet the objective, and dropping it saves about two minutes.

#### M3. The meta-analysis omits heterogeneity, and the interpretation overclaims

- **Evidence.**
  - The word "heterogeneity" does not appear in any lesson or pipeline file. The `result` target records the pooled r, its CI, the methods and the software versions, but not τ², I² or a prediction interval (`pipelines/_targets_health_wellbeing.R:107-123`).
  - TODO 2 asks for sentences on "how differences between study populations and measurements limit what the pooled estimate tells us" (`pipelines/exercise/health_wellbeing_report.qmd:82-85`), but the report contains no evidence of those differences.
  - The optional step says the pooled correlation "stays at about 0.363. This is a quick sensitivity check: the result does not depend on this choice of estimator" (`07_modify_and_reproduce.qmd:133-135`). The revision's checks confirm only which targets rebuild (`workshop-revision.diff:112`), not the DL estimate.
  - For the general-population subset, "The subset's pooled correlation is similar, with a wider interval from fewer studies" (`07_modify_and_reproduce.qmd:100-101`). This compares a subset with the whole it came from, not with the other subgroup.
- **What an attendee would experience.** AIMOS attendees critique exactly this kind of reporting: a random-effects estimate with a narrow CI and no heterogeneity or prediction interval. Someone would raise it in the discussion, and it weakens the session's claim to model good practice. "Does not depend on this choice of estimator" overgeneralises from a single alternative estimator.
- **Suggested change.**
  - Add `tau2`, `I2` and a prediction interval (`prediction = TRUE`) to `result` and to the report's Results section.
  - Rewrite TODO 2 so it interprets the prediction interval.
  - Replace the sensitivity sentence with the verified DL value and the wording "in this example, switching from REML to DL changed the pooled r by …".
  - Call the subset comparison descriptive, and mention that a subgroup analysis by `population` is the standard approach.

#### M4. The provenance chain stops before release

- **Evidence.**
  - `.gitignore:216` and `.gitignore:219` ignore `outputs/health-wellbeing/` and `workspace/`.
  - The codebook and dataspice files are written to `outputs/health-wellbeing/` (`03_data_documentation.qmd:84`, `03_data_documentation.qmd:120`). The pins board and `meta-summary.csv` are there too, and the attendee's pipeline and report are in `workspace/`.
  - Yet the opening says "Every later stage of the workshop is a tracked text file: the lockfile, metadata templates, the pipeline, and the report", and that workspace copies "can be recreated from the tracked files" (`01_open_science.qmd:103-107`). An attendee's completed TODOs and interpretation sentence cannot be recreated from tracked files.
  - The archiving page says "one release ties together the pipeline script, the report source, the lockfile, and the metadata" (`08_archiving.qmd:37-40`). The recap points to `codebook.csv`, `dataspice.json` and `meta-summary.csv` (`09_discussion.qmd:26-28`).
  - The report's only data identifier is "Dataset pin version" (`pipelines/health_wellbeing_report.qmd:85`). The material itself says that identifier is local: "If you recreate the board elsewhere, it receives new identifiers" (`04_versioning.qmd:82-84`). The raw checksum and the filter are stored in the pin metadata (`pipelines/prepare_health_wellbeing.R:74`, `pipelines/prepare_health_wellbeing.R:85-91`) but never reach the summary or the report.
  - Step 1 of the modify segment says "This is what happens when a collaborator runs the pipeline for the first time" (`07_modify_and_reproduce.qmd:29-30`). A collaborator would have no board, would recreate it with new identifiers, and would get a different `data_version`.
- **What an attendee would experience.** The data steward will ask what would actually go into the deposit. The archive checklist (`08_archiving.qmd:73-79`) names files that the session put in ignored folders. The question for the room, "which single item would help a reader recreate the precise input?" (`08_archiving.qmd:105-106`), has an answer that the report attendees just built does not contain. That breaks the "how the tools connect" story at its final link.
- **Suggested change.**
  - Carry `raw_md5`, the scope or filter, and the pin's content hash from the pin metadata into `result` and the report's Provenance section.
  - Reword the sentence at `07_modify_and_reproduce.qmd:29-30`.
  - In `08`, spend one minute on which files from this session would be committed or attached to a release, and why generated outputs are recreated from code rather than committed.

#### M5. The announced abstract promises more hands-on integration than the session delivers

- **Evidence.**
  - The announcement says "Participants will develop a workflow integrating GitHub, renv, Docker, targets, Quarto, and Zenodo" and "will gain practical experience developing a workflow that can be shared, reproduced, and archived" (`ANNOUNCEMENTS.md:21-22`, `ANNOUNCEMENTS.md:36-38`).
  - The hands-on time covers targets and Quarto only (`pages/1_introduction.qmd:46-48`). Git practice is follow-up work (`01_open_science.qmd:130-136`), environments are a demonstration, and archiving is conceptual.
  - Four tools the abstract does not mention (codebook, dataspice, pins and vetiver) take 15 minutes of demonstration (`pages/1_introduction.qmd:44-45`).
  - Git, Quarto and Zenodo have after-workshop sections, but renv and Docker do not. Applying them to my own project gets only the four-step cycle (`02_environments.qmd:73-78`) and further-reading links.
  - A better-matched abstract already exists, unpublished (`draft/workshop_plan.qmd:138-156`).
- **What an attendee would experience.** An attendee who signed up to integrate GitHub, renv, Docker and Zenodo will watch most of that and practise only the analysis core.
- **Suggested change.**
  - Use the proposed abstract if announcements can still change. Otherwise, say plainly at minute 0 which parts are hands-on and which are demonstrations.
  - Add a 30-second Git step to `07`, for example `git diff --no-index pipelines/_targets_health_wellbeing.R workspace/_targets.R`, so attendees see their own change as a diff.
  - Add an "After the workshop: renv and Docker for your own project" section, covering `renv::init()`, `renv::snapshot()` and a minimal `rocker/r-ver` Dockerfile.

#### M6. The first 35 minutes are dense with tools, and vetiver connects to nothing later

- **Evidence.**
  - Before attendees do anything themselves, the first half introduces Git, GitHub, renv, Docker, Binder, GitHub Actions, Docker Compose, GHCR, codebook, dataspice, pins and vetiver. The only attendee activity is one minute of discussion with a neighbour (`01_open_science.qmd:109-114`).
  - The Docker section spends part of its four minutes on the project's own release machinery: "reads `VERSION` into `APP_VERSION` … Docker Compose uses `APP_VERSION` to select the Dockerfile and tag the image" (`02_environments.qmd:110-112`).
  - The vetiver models "give each study equal weight and illustrate model versioning only" (`04_versioning.qmd:100-102`). No later step uses them.
- **What an attendee would experience.** I would be tired before the hands-on work begins. I would remember Compose tags better than how to put my own analysis in a container. Three minutes on a model I am told not to interpret, and which nothing later uses, works against the message that the tools connect.
- **Suggested change.**
  - Give each demonstration one 30–60 second attendee action, for example running `pin_versions()` or opening `dataspice.json`.
  - Cut the Compose and GHCR details to a sentence.
  - Either reduce vetiver to a one-minute mention with the code in a supplement, or tie it to the pipeline. The time saved could become a buffer for the hands-on segments.

#### M7. The workshop redistributes data whose reuse terms it tells attendees to check

- **Evidence.**
  - "The workshop repository includes the authors' data file at `data/raw/healthwellbeing.rda`" (`00_preparation.qmd:28-30`). This is new in the revision; previously attendees downloaded the file.
  - Publishing a release means "Zenodo also archives the tagged files" (`08_archiving.qmd:34-35`).
  - Yet attendees are told: "A package licence or the workshop repository's MIT licence should not be assumed to relicense every upstream dataset; check the relevant reuse terms before redistributing data" (`00_preparation.qmd:164-167`), and to confirm reuse terms "before including the raw file … in a deposit" (`08_archiving.qmd:81-83`).
  - The dataspice licence is left blank (`03_data_documentation.qmd:187-188`), while the recap says dataspice recorded "reuse terms" (`09_discussion.qmd:26`). The review of "upstream reuse terms" is unticked (`draft/workshop_plan.qmd:244-245`).
- **What an attendee would experience.** A data steward or librarian will ask in the discussion what the basis for redistribution is. At an open-science conference, an unanswered question here undermines the lesson.
- **Suggested change.** State the reuse basis for the file in "Record the source" (`00_preparation.qmd:161-167`) and use it to fill the dataspice licence field. If no basis can be found, go back to downloading the file during preparation and keep it out of the repository and its archives. Make the recap at `09_discussion.qmd:26` match what was actually recorded.

### Minor

#### m1. A TODO marker remains after all TODOs are complete

The template's subtitle is "Workshop report: complete TODO 1 to TODO 3" (`pipelines/exercise/health_wellbeing_report.qmd:3`). The checkpoint says "No TODO markers remain" (`06_quarto.qmd:144`), but no step removes the subtitle, so an attendee who did everything right will think they missed something. Step 1 also promises "three **TODO** markers" (`06_quarto.qmd:48-49`), while four appear. Either drop the subtitle or add "update the subtitle" to TODO 3.

#### m2. Terms are used before they are introduced

- `box::use()` appears from `03_data_documentation.qmd:39` onwards and is never explained.
- `crew_controller_local()` (`pipelines/exercise/_targets_health_wellbeing.R:14-25`) and `invisible(loadNamespace("visNetwork"))` (`05_targets.qmd:69`) are not explained.
- The `01` checkpoint asks about "a push to a remote" (`01_open_science.qmd:123-124`), but the terms table defines Remote, not push (`01_open_science.qmd:83-89`).

Add one sentence each, or replace `box::use()` with `library()` or `pkg::fun()`, which more attendees will recognise.

#### m3. Completing TODO 1 can only be confirmed visually

"Both missing arrows should now appear. If you're using the PDF, follow the text diagram above." (`05_targets.qmd:159-161`). Following the static diagram does not confirm that your own edit worked. Under `ACCESSIBILITY.md:24-25`, which asks for equivalent ways to understand information presented through images or interaction, offer a text check such as `targets::tar_network(script = pipeline_script, targets_only = TRUE)$edges`. Point screen-reader users to it as well as PDF readers.

#### m4. Notes for maintainers appear in attendee pages

Examples: "The R chunks are also configured to run during rendering; setup chunks are uncached and other R chunks use the cache" (`00_preparation.qmd:87-89`). "Keep the board with the document cache; if you remove the board, refresh the cache when rendering again" (`04_versioning.qmd:129-133`). "so it can render in a fresh R session" (`03_data_documentation.qmd:28-30`). Under time pressure these are noise. Move them to `README.md` or into comments.

#### m5. Moving between windows and panes creates friction

Each hands-on segment switches between the Console and the Terminal, for example a bash block (`06_quarto.qmd:34-40`) followed by an R chunk (`06_quarto.qmd:131-136`). Nothing says whether RStudio's **Render** button works on `workspace/report.qmd`, which most RStudio users will try first. Nothing explains how to keep the lesson pages open alongside RStudio in the same browser, which is harder for people using zoom or magnification. Consider `quarto::quarto_render("workspace/report.qmd")` in the Console, and add one line about window layout to `00`.

#### m6. The metadata demonstration never shows the metadata

The export chunk prints only `file.exists(...)` (`03_data_documentation.qmd:178-179`). The checkpoint then asks attendees to look for fields in `dataspice.json` (`03_data_documentation.qmd:185-186`). The live edit to `attributes.csv` (`03_data_documentation.qmd:171-173`) is not in the code. For the data steward, the JSON-LD is the payoff. Print a short excerpt.

#### m7. The export instruction loses the session's outputs

"select the `workspace` folder … Your pipeline and report copies are there" (`09_discussion.qmd:56-58`). The board, `meta-summary.csv` and the metadata files are in `outputs/health-wellbeing/` and would be lost. Mention that folder too, or explain that the preparation script recreates the board with new identifiers.

#### m8. The expected interval is rounded inconsistently

The targets checkpoint gives "about **0.31 to 0.41**" (`05_targets.qmd:199-200`), while the Quarto checkpoint gives "**0.309 to 0.415**" (`06_quarto.qmd:140-141`). Rounding 0.415 to two decimals gives 0.42, so an attendee comparing the two may wonder whether something went wrong. Use one precision throughout.

#### m9. The page says R is restarted, but nothing restarts it

"Restarting R and loading the data from its explicit path checks that the analysis does not depend on objects left over" (`02_environments.qmd:135-137`). The chunk that follows does not restart R. Add "Session → Restart R" or remove the claim.

## 4. Questions I would ask the presenter

1. Has anyone completed every participant step in a fresh MyBinder launch, timed, with several people launching at once? What exactly is the "prepared alternative" (`00_preparation.qmd:50-51`)?
2. Does `quarto render workspace/report.qmd` render it on its own, outside the book project, with `report.html` in `workspace/` and its chunks evaluated? Does the RStudio **Render** button work on that file?
3. Should we do the preparation on the morning, in the session we will use? What happens if MyBinder shuts down an idle session during the 35 minutes of demonstrations?
4. Will helpers be in the room during the 40 minutes of hands-on work?
5. Why does the report omit τ², I² and a prediction interval? What is the DL estimate behind "stays at about 0.363"?
6. What reuse terms allow `data/raw/healthwellbeing.rda` to be in the repository and in its Zenodo archive?
7. Given that `outputs/` and `workspace/` are ignored, which files from this session would you commit or attach to a release?
8. Will the announced description be replaced with the revised abstract in `draft/workshop_plan.qmd:138-156`?
9. Why demonstrate vetiver on a model we are told not to interpret, rather than give that time to the hands-on segments?

## 5. Is the main learning outcome achievable?

The stated main outcome is to "understand and experience an end-to-end reproducible research workflow, not to master every individual package" (`pages/1_introduction.qmd:23-24`).

- **Understand: largely yes.** The recap table (`09_discussion.qmd:22-30`) and the consistent single example give a typical attendee a coherent model of what each tool records.
- **Experience: partly, and only if B1 is resolved.** Attendees experience the middle of the workflow: a pinned input, a pipeline, a report, and a change followed by a rerun. They watch both ends: version control, environment capture, metadata, and release and archive. Because of M4, the end they watch is not connected to what they built.

Against the individual objectives (`pages/1_introduction.qmd:30-36`):

| Objective | Assessment |
| --- | --- |
| Explaining how the tools support the workflow | Achievable |
| Describing metadata, including licensing and access | Only partly: the licence is left blank (M7) |
| Explaining how pins and vetiver link results to versions | pins yes; vetiver is never linked to a result (M6) |
| Completing and running the pipeline and rendering the report | Achievable if MyBinder and the report render work (B1) |
| Modifying an input and rebuilding only what is affected | Not met in the core path (M2) |
| Identifying the files needed for a release and archive | Achievable as a list, but not shown with the session's own files (M4) |

Fixing B1 and M1 would make the hands-on half dependable. M2 to M4 are the changes that would most improve what this audience takes away, and none of them needs more time. For the attendee with little R experience, the outcome is achievable mainly through the solutions and catch-up steps. For the data steward, the metadata and archiving end is the weakest part.

This is a simulated attendee view based on reading the materials. It does not replace feedback from real participants, a timed rehearsal, or human review.

## Notes from the main session

The Claude Code session that prepared the revision added these notes after the
review. They record evidence the reviewer could not see and do not change its
findings.

- **B1:** During the revision, `quarto render workspace/report.qmd --to html`
  was run from the project root for both the template and the reference
  report. It ran in the RStudio image
  `ghcr.io/jbris/open-reproducible-science-r:1.0.0`, and both reports rendered
  to HTML in `workspace/`. It was not run in the Binder image or a MyBinder
  launch, and RStudio's **Render** button was not tested, so the readiness gap
  remains.
- **M3:** In the same image, the REML, Paule–Mandel and DerSimonian–Laird
  estimators and the classic interval all gave a pooled correlation of about
  0.363. I² was about 99.8%, which supports the point about unreported
  heterogeneity.
- **m8:** The interval's computed upper bound is 0.4148. It rounds to 0.41 at
  two decimals and to 0.415 at three, so both checkpoints are correctly
  rounded. Attendees may still compare the two displayed values.

## Codex review of the draft, lessons, and patch

The 90-minute structure is worth keeping. One dataset and one continuous
exercise give the workshop a clear thread. Templates, expected outputs, and
collapsed solutions make the hands-on scope plausible. Moving `synthpop` to
follow-up gives the main exercise more room. Fix the participant workflow
before delivering the session.

### Findings in priority order

1. **Rendering the book overwrites unfinished participant work.** In a
   disposable project copy, I added a note to an unfinished
   `workspace/_targets.R` and rendered the HTML book. The catch-up chunk
   replaced the script with the reference solution and erased the note.
   Run the book examples in a separate directory and make participant
   recovery an explicit action that preserves existing files.
   [Targets catch-up step](../pages/workshop/05_targets.qmd)
2. **The recovery instructions fail in a fresh session.** The Quarto lesson
   sends late arrivals to a chunk that assumes the dataset versions exist
   and `pipeline_script` has been defined. Give participants one recovery
   command that prepares missing inputs and gets them to a working report.
   Rehearse it from the exact MyBinder link participants will receive.
   [Quarto lesson](../pages/workshop/06_quarto.qmd)
3. **Make selective rebuilding part of the timed exercise.** The subset
   switch makes every target outdated. The optional estimator change
   rebuilds only `fit`, `result`, and `summary_file`, so make that the
   timed exercise and keep the subset switch as an extension. Describe
   the estimator comparison as a small change in the pooled estimate for
   this dataset. [Modify and reproduce](../pages/workshop/07_modify_and_reproduce.qmd)
4. **Report between-study heterogeneity.** The local run reproduced a
   pooled correlation of 0.363 and I² of about 99.8%. Include a
   heterogeneity measure and explain that the confidence interval describes
   uncertainty in the pooled average.
   [Reference report](../pipelines/health_wellbeing_report.qmd) ·
   [Original worked example](https://doing-meta.guide/pooling-es#correlations)
5. **Show exactly what to export for an archive.** The pin ID identifies
   a version on the participant's local board. Exporting `workspace/`
   leaves behind the summary CSV, input selection, and metadata. Give
   participants one checklist that ties the exact script and report to
   the summary, source checksum, inclusion rule, and environment record.
   Document the reuse basis for any data included. The raw file predates
   this revision, which corrects the claim in M7 that it was newly added.
   [Archiving lesson](../pages/workshop/08_archiving.qmd) ·
   [Export instructions](../pages/workshop/09_discussion.qmd)

### Draft and patch

- The schedule matches across the draft, introduction, and lessons. The
  first 35 minutes cover many tools. Give each demonstration one artifact
  to inspect and make the second `vetiver` model a follow-up if time is
  tight. The draft abstract describes the split between demonstrations
  and hands-on work more accurately than the current announcement.
  [Draft abstract](workshop_plan.qmd#proposed-revised-abstract) ·
  [Announcement](../ANNOUNCEMENTS.md#abstract--description)
- Applying the patch (`workshop-revision.diff`) to `8b88f32` in a
  temporary Git index recreated `ef8b138` apart from the patch file
  itself. Consolidate the validation record. The patch and draft report
  successful renders, while the commit message for `ef8b138` reports
  parse checks only.
- GitHub Pages serves `main:/docs`, which still contains the old
  programme. Refresh the HTML and PDF and add redirects for renamed
  chapters before announcing the revision.
  [Quarto redirect guidance](https://quarto.org/docs/websites/website-navigation.html#redirects)

### Verification

Codex reviewed the source and patch and rendered a disposable project
copy in the local RStudio image with R 4.4.1 and Quarto 1.5.57. All seven
R scripts parsed. The HTML book and standalone participant report
rendered, and the synthetic comparison PNG was generated. PDF rendering
was outside this independent check. A fresh MyBinder launch, timed
rehearsal, and human review are pending.

## Follow-up on the selected findings

| Finding | Change |
| --- | --- |
| M1 | The three hands-on lessons offer a recovery command that prepares missing inputs, backs up working files, and restores the reference pipeline and report. Book renders use separate outputs. |
| M2 | The REML-to-DL change is timed. The dataset switch is an extension. |
| M3 | The report gives τ², I², and a prediction interval. The exercise compares the two estimators on these data and describes the subset comparison as descriptive. |
| M4 | The report links the exact script, dataset and model versions, checksums, and inclusion rule to the result. The archiving lesson distinguishes files to track from artifacts to attach. |
| M5 | The announcement separates demonstrations from hands-on work. The opening sets the same expectations, and there is follow-up guidance for Git, renv, and Docker. |
| M7 | The bundled file was already tracked. Its Git blob matches the file at a pinned upstream dmetar revision. The upstream MIT notice is included and the licence is visible in the JSON-LD. |
| m1–m3 | The report template contains three TODOs. The lessons define push and explain package imports and the worker. Participants can check both dependency edges in text. |
| m4–m6 | Render mechanics are in the README or hidden setup. Participants can render from the R Console. The metadata lesson shows an excerpt of the exported JSON-LD. |
| m7–m9 | The export checklist includes analysis outputs and pins. Correlations and interval bounds use three decimals. The environment exercise describes the R session it actually records. |
| Model versioning | A pipeline branch trains and pins an illustrative regression from the checked study summaries. The report names its exact model version. Changing the input retrains the regression and records a new version. |

Codex implemented the follow-up. In the local RStudio image, recovery from a
clean store worked, a second recovery preserved an edited pipeline as a backup,
and full invalidation reproduced the original summary and reused the model pin.
The estimator edit rebuilt four targets and left the model pin unchanged. The
optional subset built an 18-study result and a distinct model pin whose metadata
matched the selected dataset version and checksum. Both standalone reports
rendered from the Console helper. The HTML book and PDF rendered, the
synthetic comparison figure was included in the HTML, and the book render
left an unfinished participant script and a participant selection file
untouched.

A fresh MyBinder launch, timed rehearsal, and human review remain pending.
