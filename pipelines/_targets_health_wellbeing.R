workshop_dir <- file.path("outputs", "health-wellbeing")

list(
  targets::tar_target(
    version_file,
    file.path(workshop_dir, "analysis-data-version.txt"),
    format = "file"
  ),
  targets::tar_target(
    code_revision_file,
    file.path(workshop_dir, "code-revision.txt"),
    format = "file"
  ),
  targets::tar_target(data_version, {
    version <- trimws(readLines(version_file, warn = FALSE))
    stopifnot(length(version) == 1L, nzchar(version))
    version
  }),
  targets::tar_target(
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
  targets::tar_target(studies, {
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
  targets::tar_target(fit, {
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
      r_version = as.character(getRversion()),
      meta_version = as.character(getNamespaceVersion("meta"))
    )
  }),
  targets::tar_target(result, {
    code_revision <- readLines(code_revision_file, warn = FALSE)
    stopifnot(length(code_revision) == 1L, grepl("^[0-9a-f]{40}$", code_revision))

    model <- fit$model
    data.frame(
      data_version = data_version,
      code_revision = code_revision,
      studies = model$k,
      pooled_r = tanh(model$TE.random),
      ci_lower = tanh(model$lower.random),
      ci_upper = tanh(model$upper.random),
      confidence_level = model$level.ma,
      effect_scale = model$sm,
      tau_method = model$method.tau,
      interval_method = model$method.random.ci,
      r_version = fit$r_version,
      meta_version = fit$meta_version
    )
  }),
  targets::tar_target(
    summary_file,
    {
      path <- file.path(workshop_dir, "meta-summary.csv")
      utils::write.csv(result, path, row.names = FALSE)
      path
    },
    format = "file"
  )
)
