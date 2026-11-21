# Run from the project root to restore the full-dataset REML baseline.
local({
  source("pipelines/workshop_support.R", local = TRUE)
  workshop_dir <- workshop_output_dir()
  source("pipelines/prepare_health_wellbeing.R", local = TRUE)

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

  script <- file.path("workspace", "_targets.R")
  restore_reference("pipelines/_targets_health_wellbeing.R", script)
  targets::tar_make(script = script, store = file.path(workshop_dir, "_targets"))
})
