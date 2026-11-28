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
# file, which serves as the solution and the copy that recover_workshop.R restores.

box::use(
  crew[crew_controller_local],
  targets[tar_option_set, tar_path_script, tar_target]
)

withr::with_dir(
  here::here(),
  source("pipelines/workshop_support.R", local = TRUE)
)
workshop_dir <- workshop_output_dir()
pipeline_script <- tar_path_script()

# Run the targets in one local background worker.
tar_option_set(
  controller = crew_controller_local(workers = 1)
)

list(
  # 1. The selection file names the pinned dataset version to analyse.
  tar_target(
    version_file,
    here::here(workshop_dir, "analysis-data-version.txt"),
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
      board_path <- here::here(workshop_dir, "data_store")
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

  tar_target(data_provenance, {
    board <- pins::board_folder(here::here(workshop_dir, "data_store"), versioned = TRUE)
    pin <- pins::pin_meta(board, "health_wellbeing", version = data_version)
    list(
      source_url = pin$user$source_url,
      raw_md5 = pin$user$raw_md5,
      scope = pin$user$scope,
      filter = if (is.null(pin$user$filter)) "all studies" else pin$user$filter,
      data_file_md5 = unname(tools::md5sum(dataset_file))
    )
  }),

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
      level.ma = 0.95,
      prediction = TRUE,
      level.predict = 0.95
    )
    list(
      model = model,
      r_version = as.character(getRversion()),
      meta_version = as.character(getNamespaceVersion("meta"))
    )
  }),

  # A separate model uses the same checked input and has its own pin.
  tar_target(predictive_model, {
    training <- data.frame(z = atanh(studies$cor), log_n = log(studies$n))
    model <- stats::lm(z ~ log_n, data = training)
    metadata <- list(
      data_version = data_version,
      data_file_md5 = data_provenance$data_file_md5,
      recipe = "Fisher z ~ log(sample size), unweighted",
      r_version = as.character(getRversion()),
      vetiver_version = as.character(utils::packageVersion("vetiver"))
    )
    metadata$model_key <- digest::digest(
      list(metadata, stats::coef(model), deparse1(stats::formula(model))),
      algo = "sha256"
    )
    vetiver::vetiver_model(model, "health_wellbeing_lm", metadata = metadata)
  }),

  tar_target(model_pin_files, {
    board <- pins::board_folder(here::here(workshop_dir, "model_store"), versioned = TRUE)
    name <- predictive_model$model_name
    previous <- if (pins::pin_exists(board, name)) {
      pins::pin_versions(board, name)$version
    } else {
      character()
    }
    matches <- vapply(previous, function(version) {
      stored <- pins::pin_meta(board, name, version = version)
      identical(stored$user$model_key, predictive_model$metadata$user$model_key)
    }, logical(1))
    version <- if (any(matches)) {
      previous[which(matches)[1L]]
    } else {
      vetiver::vetiver_pin_write(board, predictive_model)
      created <- setdiff(pins::pin_versions(board, name)$version, previous)
      stopifnot(length(created) == 1L)
      created
    }
    model_version_file <- here::here(workshop_dir, "predictive-model-version.txt")
    writeLines(version, model_version_file)
    c(model_version_file, pins::pin_download(board, name, version = version))
  }, format = "file"),

  tar_target(model_version, readLines(model_pin_files[[1L]])),

  tar_target(pipeline_file, pipeline_script, format = "file"),

  # 6. Summarise the pooled estimate on the correlation scale, with provenance.
  tar_target(result, {
    model <- fit$model
    data.frame(
      data_version = data_version,
      data_source = data_provenance$source_url,
      raw_md5 = data_provenance$raw_md5,
      data_scope = data_provenance$scope,
      data_filter = data_provenance$filter,
      data_file_md5 = data_provenance$data_file_md5,
      predictive_model_version = model_version,
      studies = model$k,
      pooled_r = tanh(model$TE.random),
      ci_lower = tanh(model$lower.random),
      ci_upper = tanh(model$upper.random),
      confidence_level = model$level.ma,
      tau2 = model$tau2,
      i2_percent = 100 * model$I2,
      prediction_lower = tanh(model$lower.predict),
      prediction_upper = tanh(model$upper.predict),
      prediction_level = model$level.predict,
      prediction_method = model$method.predict,
      effect_scale = model$sm,
      tau_method = model$method.tau,
      interval_method = model$method.random.ci,
      r_version = fit$r_version,
      meta_version = fit$meta_version,
      pipeline_md5 = unname(tools::md5sum(pipeline_file))
    )
  }),

  # 7. Write the summary that the Quarto report reads.
  tar_target(
    summary_file,
    {
      path <- here::here(workshop_dir, "meta-summary.csv")
      utils::write.csv(result, path, row.names = FALSE)
      path
    },
    format = "file"
  )
)
