# HealthWellbeing correlation meta-analysis: completed reference pipeline.
#
# Prepare the inputs first with pipelines/prepare_health_wellbeing.R, then run
# from the project root:
#   targets::tar_make(
#     script = "pipelines/_targets_health_wellbeing.R",
#     store = "outputs/health-wellbeing/_targets"
#   )
#
# The partially completed template for the hands-on activity is
# pipelines/exercise/_targets_health_wellbeing.R. Its numbered steps match this
# file, which serves as the solution and the catch-up copy.

box::use(
  crew[crew_controller_local],
  targets[tar_option_set, tar_path_script, tar_target]
)

workshop_dir <- file.path("outputs", "health-wellbeing")
pipeline_script <- tar_path_script()

# Run the targets in one local background worker.
tar_option_set(
  controller = crew_controller_local(workers = 1)
)

list(
  # 1. The selection file names the pinned dataset version to analyse.
  tar_target(
    version_file,
    file.path(workshop_dir, "analysis-data-version.txt"),
    format = "file"
  ),

  # 2. Read the selected version identifier.
  tar_target(data_version, {
    version <- trimws(readLines(version_file, warn = FALSE))
    stopifnot(length(version) == 1L, nzchar(version))
    version
  }),

  # 3. Retrieve that exact version from the versioned pins board.
  tar_target(
    dataset_file,
    {
      board_path <- file.path(workshop_dir, "data_store")
      stopifnot(dir.exists(board_path))

      board <- pins::board_folder(board_path, versioned = TRUE)
      files <- pins::pin_download(
        board,
        "health_wellbeing",
        version = data_version
      )
      stopifnot(length(files) == 1L, file.exists(files))
      files
    },
    format = "file"
  ),

  # 4. Read the study summaries and check the assumptions the model needs.
  tar_target(studies, {
    data <- readRDS(dataset_file)
    stopifnot(
      is.data.frame(data),
      all(c("author", "cor", "n") %in% names(data)),
      nrow(data) > 1L,
      !anyNA(data$author),
      !anyDuplicated(data$author),
      is.numeric(data$cor),
      all(is.finite(data$cor)),
      all(abs(data$cor) < 1),
      is.numeric(data$n),
      all(is.finite(data$n)),
      all(data$n > 3),
      all(data$n == floor(data$n))
    )
    data
  }),

  # 5. Pool the correlations with a random-effects model on Fisher's z scale.
  tar_target(fit, {
    pipeline_md5 <- unname(tools::md5sum(pipeline_script))
    stopifnot(!is.na(pipeline_md5))

    model <- meta::metacor(
      cor = cor,
      n = n,
      studlab = author,
      data = studies,
      sm = "ZCOR",
      common = FALSE,
      random = TRUE,
      method.tau = "REML",
      method.random.ci = "HK",
      level.ma = 0.95
    )
    list(
      model = model,
      pipeline_md5 = pipeline_md5,
      r_version = as.character(getRversion()),
      meta_version = as.character(getNamespaceVersion("meta"))
    )
  }),

  # 6. Summarise the pooled estimate on the correlation scale, with provenance.
  tar_target(result, {
    model <- fit$model
    data.frame(
      data_version = data_version,
      studies = model$k,
      pooled_r = tanh(model$TE.random),
      ci_lower = tanh(model$lower.random),
      ci_upper = tanh(model$upper.random),
      confidence_level = model$level.ma,
      effect_scale = model$sm,
      tau_method = model$method.tau,
      interval_method = model$method.random.ci,
      r_version = fit$r_version,
      meta_version = fit$meta_version,
      pipeline_md5 = fit$pipeline_md5
    )
  }),

  # 7. Write the summary that the Quarto report reads.
  tar_target(
    summary_file,
    {
      path <- file.path(workshop_dir, "meta-summary.csv")
      utils::write.csv(result, path, row.names = FALSE)
      path
    },
    format = "file"
  )
)
