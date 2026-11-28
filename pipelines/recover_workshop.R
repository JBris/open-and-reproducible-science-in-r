# Run from the project root to restore the full-dataset REML baseline.
local({
  withr::with_dir(
    here::here(),
    source("pipelines/workshop_support.R", local = TRUE)
  )
  workshop_dir <- workshop_output_dir()
  withr::with_dir(
    here::here(),
    source("pipelines/prepare_health_wellbeing.R", local = TRUE)
  )

  dir.create("workspace", showWarnings = FALSE)
  restore_reference <- function(reference, working_copy) {
    if (file.exists(working_copy)) {
      if (identical(unname(tools::md5sum(reference)), unname(tools::md5sum(working_copy)))) {
        return(invisible(NULL))
      }
      backup <- tempfile(
        pattern = paste0(basename(working_copy), "-"),
        tmpdir = "workspace",
        fileext = paste0(".", tools::file_ext(working_copy))
      )
      stopifnot(file.copy(working_copy, backup))
      message("Saved your previous file as ", backup)
    }
    stopifnot(file.copy(reference, working_copy, overwrite = TRUE))
  }

  script <- here::here("workspace", "_targets.R")
  restore_reference("pipelines/_targets_health_wellbeing.R", script)
  targets::tar_make(script = script, store = here::here(workshop_dir, "_targets"))
})
