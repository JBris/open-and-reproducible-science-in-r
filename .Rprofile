setHook("rstudio.sessionInit", function(newSession) {
  if (newSession && is.null(rstudioapi::getActiveProject())) {
    rstudioapi::openProject(
      "/home/rstudio/open-and-reproducible-science-in-r.Rproj"
    )
  }
}, action = "append")

source("renv/activate.R")
