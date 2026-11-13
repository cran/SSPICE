## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", eval = FALSE)

## ----report-step--------------------------------------------------------------
# source(file.path("scripts", "11_correction_quality_report.R"))

## ----quality-config, eval=FALSE-----------------------------------------------
# pkgload::load_all(".", export_all = FALSE, helpers = FALSE)
# run <- new.env(parent = globalenv())
# sys.source("scripts/00_config.R", envir = run)
# run$config$correction_output_dir <- "output/corrected-full-STRATUM"
# run$config$correction_quality_output_dir <- file.path(
#   run$config$correction_output_dir, "quality-report"
# )
# run$correction_quality_report <- SSPICE::correction_quality_report
# run$`%||%` <- function(x, y) if (is.null(x)) y else x
# sys.source("scripts/11_correction_quality_report.R", envir = run)

