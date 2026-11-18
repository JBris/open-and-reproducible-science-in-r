---
name: quarto-workshop
description: Create or revise Quarto workshop lessons, exercises, navigation, and HTML or PDF output in this repository.
---

# Quarto workshop development

Read `AGENTS.md`, `AI_POLICY.md`, `_quarto.yml`, and nearby lessons. Explain the
learning objective, prerequisites, and expected result clearly for participants.
Connect examples to open and reproducible science and verify new factual claims
and citations against appropriate sources.

- Keep `pages/` reusable across workshops. Event names, dates, and venues belong
  in `ANNOUNCEMENTS.md`. The unpublished plan is `draft/3_workshop_plan.qmd`;
  preserve the draft render exclusion and keep it out of the sidebar. Link to
  repository source when referring to an unpublished draft from the README.
- Root `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, and `AI_POLICY.md`
  are website inputs. Update README/sidebar references when moving published
  documents. GitHub workflows and issue/PR templates keep their discovery paths
  under `.github/` and are not workshop pages.
- Check that referenced lessons exist. Keep paths, sidebar entries, headings,
  links, and figure references consistent.
- Distinguish planned pins/vetiver metadata and versioning exercises and the
  differential privacy extension from implemented examples. The R and pipeline
  helpers currently contain no-op placeholders.
- Preserve fenced code languages and Quarto cell options. Use examples compatible
  with the project's pinned environment; avoid hidden session state and installing
  packages inside lessons.
- The project sets `execute.eval: false`. Preserve that default unless execution
  is requested. Static rendering does not verify R results.
- Render changed lessons as HTML with `quarto render path/to/lesson.qmd --to html`
  when the toolchain is available. For shared configuration changes, render the
  website and inspect navigation. Check PDF when the task affects that format.
- For requested execution, inspect code and required data first and use the
  restored project environment. Report missing prerequisites and failures.
- Keep generated output and agent instructions out of the published site.

Summarise the teaching or navigation change, which output was checked, whether
R code actually ran, and any limitations. Disclose material AI assistance when
preparing a contribution; keep agent verification distinct from human review.
