## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", eval = FALSE)

## ----build-dag----------------------------------------------------------------
# source(file.path("scripts", "00_config.R"))
# dag <- SSPICE::build_DAG(
#   routing = config$routing_file,
#   separator = config$metadata_separator,
#   na_strings = config$missing_codes,
#   analyze = TRUE,
#   stop_on_cycle = TRUE,
#   max_paths_per_partition = config$max_paths_per_partition
# )
# names(dag)
# dag$graph_diagnostics

## ----inspect-dag--------------------------------------------------------------
# source(file.path("scripts", "01_build_DAG.R"))
# dag <- readRDS(file.path(config$dag_output_dir, "questionnaire_DAG.rds"))
# str(dag$graph_diagnostics, max.level = 1)
# utils::head(dag$routes_numeric)

