## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", eval = FALSE)

## ----correction-steps---------------------------------------------------------
# source(file.path("scripts", "09_build_extended_DAG.R"))
# source(file.path("scripts", "10_correct_data.R"))

## ----full-run, eval=FALSE-----------------------------------------------------
# run <- new.env(parent = globalenv())
# sys.source("scripts/00_config.R", envir = run)
# run$config$correction_record_limit <- Inf
# run$config$correction_strata <- "STRATUM"
# run$config$correction_batch_size <- 100L
# run$config$correction_resume_batches <- FALSE
# run$config$correction_cache_policy <- "auto"
# run$config$correction_control_args$freeze_strata <- TRUE
# run$config$correction_control_args$use_parallel <- TRUE
# run$config$correction_control_args$parallel_workers <- 6L
# run$config$correction_output_dir <- "output/corrected-full-STRATUM"
# stopifnot(!dir.exists(run$config$correction_output_dir))
# sys.source("scripts/10_correct_data.R", envir = run)

