# Shared paths and report command for the workshop lessons.
workshop_output_dir <- function() {
  Sys.getenv("WORKSHOP_OUTPUT_DIR", unset = file.path("outputs", "health-wellbeing"))
}

use_workshop_book_outputs <- function() {
  if (isTRUE(getOption("knitr.in.progress"))) {
    Sys.setenv(WORKSHOP_OUTPUT_DIR = file.path("outputs", "health-wellbeing", "book"))
  }
}

render_workshop_report <- function(path = file.path("workspace", "report.qmd")) {
  if (!file.exists(path)) {
    stop("Report source missing: ", path, ". See the Quarto lesson's recovery step.")
  }
  if (!nzchar(Sys.which("quarto"))) {
    stop("Quarto is unavailable. Open the prepared workshop environment.")
  }
  status <- system2("quarto", c("render", shQuote(path), "--to", "html"))
  if (!identical(status, 0L)) {
    stop("The report did not render. Check the first error above for the affected line.")
  }
  invisible(sub("\\.qmd$", ".html", path))
}
