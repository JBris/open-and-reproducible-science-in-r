# Run from the project root before the versioning demonstration.
local({
  withr::with_dir(
    here::here(),
    source("pipelines/workshop_support.R", local = TRUE)
  )
  withr::with_dir(
    here::here(),
    source("pipelines/prepare_health_wellbeing.R", local = TRUE)
  )

  targets::tar_make(
    names = model_version,
    script = here::here("pipelines", "_targets_health_wellbeing.R"),
    store = here::here(workshop_output_dir(), "_targets")
  )
})
