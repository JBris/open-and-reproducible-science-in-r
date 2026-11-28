# Shared paths and report command for the workshop lessons.
workshop_output_dir <- function() {
  Sys.getenv("WORKSHOP_OUTPUT_DIR", unset = here::here("outputs", "health-wellbeing"))
}

use_workshop_book_outputs <- function() {
  if (isTRUE(getOption("knitr.in.progress"))) {
    Sys.setenv(WORKSHOP_OUTPUT_DIR = here::here("outputs", "health-wellbeing", "book"))
  }
}

render_workshop_report <- function(path = here::here("workspace", "report.qmd")) {
  if (!file.exists(path)) {
    stop("Report source missing: ", path, ". Copy the template in Step 1 of the Quarto exercise.")
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
