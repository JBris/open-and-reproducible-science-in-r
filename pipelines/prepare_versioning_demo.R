# Run from the project root before the versioning demonstration.
local({
  source("pipelines/workshop_support.R", local = TRUE)
  source("pipelines/prepare_health_wellbeing.R", local = TRUE)

  targets::tar_make(
    names = model_version,
    script = file.path("pipelines", "_targets_health_wellbeing.R"),
    store = file.path(workshop_output_dir(), "_targets")
  )
})
