# Run from the project root to resume the hands-on exercises.
local({
  source("pipelines/workshop_support.R", local = TRUE)
  workshop_dir <- workshop_output_dir()
  selection_file <- file.path(workshop_dir, "analysis-data-version.txt")
  board_path <- file.path(workshop_dir, "data_store")
  if (!file.exists(selection_file) ||
      !file.exists(file.path(workshop_dir, "dataset-versions.csv")) ||
      !dir.exists(board_path)) {
    source("pipelines/prepare_health_wellbeing.R", local = TRUE)
  }

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
