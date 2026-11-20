# Prepare the versioned HealthWellbeing inputs for the workshop pipeline.
#
# Run from the project root before the hands-on activities:
#   source(file.path("pipelines", "prepare_health_wellbeing.R"))
#
# The script verifies the unchanged raw teaching file, stores two dataset
# versions on a versioned local pins board, records their identifiers, and
# selects the full dataset as the pipeline's starting input. Rerunning it reuses
# matching versions instead of writing duplicates. Objects stay local to the
# script; its outputs are the files under outputs/health-wellbeing/.

local({
  workshop_dir <- file.path("outputs", "health-wellbeing")
  raw_file <- file.path("data", "raw", "healthwellbeing.rda")
  source_url <- paste0(
    "https://www.protectlab.org/meta-analysis-in-r/data/",
    "healthwellbeing.rda"
  )

  # Check that the raw file is the verified teaching snapshot.
  stopifnot(file.exists(raw_file))
  raw_md5 <- unname(tools::md5sum(raw_file))
  stopifnot(identical(raw_md5, "0d74964b0b7168379a2b015cb648b326"))

  raw_data <- new.env(parent = baseenv())
  loaded_names <- load(raw_file, envir = raw_data)
  stopifnot(identical(loaded_names, "HealthWellbeing"))
  health <- raw_data[["HealthWellbeing"]]
  stopifnot(is.data.frame(health), nrow(health) == 29L)

  # Enable versioning explicitly so the board keeps every write.
  dir.create(workshop_dir, recursive = TRUE, showWarnings = FALSE)
  board <- pins::board_folder(
    file.path(workshop_dir, "data_store"),
    versioned = TRUE
  )
  pin_name <- "health_wellbeing"

  # Return an identical stored version if one exists; otherwise write a new one.
  write_version <- function(data, description, metadata) {
    previous_versions <- character()
    if (pins::pin_exists(board, pin_name)) {
      previous_versions <- pins::pin_versions(board, pin_name)$version
      for (version in previous_versions) {
        stored_metadata <- pins::pin_meta(board, pin_name, version = version)$user
        if (identical(stored_metadata, metadata) &&
              identical(pins::pin_read(board, pin_name, version = version), data)) {
          return(version)
        }
      }
    }

    pins::pin_write(
      board,
      data,
      name = pin_name,
      type = "rds",
      title = "HealthWellbeing",
      description = description,
      metadata = metadata
    )
    new_version <- setdiff(
      pins::pin_versions(board, pin_name)$version,
      previous_versions
    )
    stopifnot(length(new_version) == 1L)
    new_version
  }

  # Version 1: all 29 studies, with the source and checksum as metadata.
  full_version <- write_version(
    health,
    description = "All 29 studies in the teaching snapshot.",
    metadata = list(source_url = source_url, raw_md5 = raw_md5, scope = "all")
  )

  # Version 2: the 18 general-population studies, derived from version 1.
  health_general <- pins::pin_read(board, pin_name, version = full_version) |>
    subset(population == "general population")
  stopifnot(nrow(health_general) == 18L)

  general_version <- write_version(
    health_general,
    description = "Only studies labelled general population.",
    metadata = list(
      source_url = source_url,
      raw_md5 = raw_md5,
      scope = "general",
      filter = "population == 'general population'",
      parent_version = full_version
    )
  )

  # Record both identifiers and start the pipeline from the full dataset.
  versions <- data.frame(
    scope = c("all", "general"),
    version = c(full_version, general_version)
  )
  utils::write.csv(
    versions,
    file.path(workshop_dir, "dataset-versions.csv"),
    row.names = FALSE
  )
  writeLines(
    full_version,
    file.path(workshop_dir, "analysis-data-version.txt")
  )
  print(versions)
})
