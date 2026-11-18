# Syntax-only validation using base R. Run with Rscript --vanilla so project
# startup cannot install dependencies or execute analysis as a side effect.
files <- commandArgs(trailingOnly = TRUE)

if (length(files) == 0L) {
  directories <- c("R", "pipelines", "tests", ".codex/scripts")
  directories <- directories[dir.exists(directories)]
  files <- unlist(lapply(directories, list.files,
    pattern = "\\.[Rr]$", recursive = TRUE, full.names = TRUE
  ), use.names = FALSE)
  if (file.exists(".Rprofile")) {
    files <- c(files, ".Rprofile")
  }
}

files <- unique(files)
if (length(files) == 0L) {
  message("No R scripts found to parse.")
  quit(status = 0L)
}

valid <- vapply(files, function(path) {
  tryCatch({
    if (!file.exists(path) || dir.exists(path)) {
      stop("R script does not exist: ", path)
    }
    invisible(parse(file = path, keep.source = FALSE))
    TRUE
  }, error = function(error) {
    message(path, ": ", conditionMessage(error))
    FALSE
  })
}, logical(1))

message(sum(valid), "/", length(files), " R scripts parsed; no code was executed.")
quit(status = if (all(valid)) 0L else 1L)
