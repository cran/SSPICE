## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", eval = FALSE)

## ----workflow-----------------------------------------------------------------
# source(file.path("scripts", "00_config.R"))
# source(file.path("scripts", "01_build_DAG.R"))
# source(file.path("scripts", "02_prepare_data.R"))
# source(file.path("scripts", "03_run_routing_check.R"))

## ----standalone-workflow, eval=TRUE-------------------------------------------
local({
  routes <- read.table(text = paste(
    "ID;1;1;9999;0;0;.;.",
    "GATE;2;1;2;0;1;1;END",
    "DETAIL;2;1;2;0;0;.;.",
    "END;1;1;1;0;0;.;.", sep = "\n"),
    sep = ";", header = FALSE, na.strings = ".")
  dag <- SSPICE::build_DAG(routes, analyze = FALSE)
  raw <- data.frame(ID = 1:3, GATE = c(1, 2, 1),
                    DETAIL = c(NA, 1, 1), END = c(1, 1, 1))
  prepared <- SSPICE::prepare_data(raw, dag)

  # The current checker requires a mapping file, even with no recoding.
  mapping <- tempfile(fileext = ".csv")
  on.exit(unlink(mapping), add = TRUE)
  write.csv(data.frame(varname = character(), item_route = numeric(),
                       item_dataset = numeric()), mapping, row.names = FALSE)
  check <- SSPICE::routing_check(
    prepared$data, dag$routes_numeric, dag$Bt, "ID",
    basename(mapping), dirname(mapping)
  )
  print(check$full_report)
  stopifnot(setequal(unique(check$full_report$ID), 3))

  # Only the erroneous row is sent to correction. Donors are fixed.
  result <- SSPICE::correct_data(
    data = prepared$data[3, , drop = FALSE], dag = dag, record_id = "ID",
    donor_data = prepared$data[1:2, , drop = FALSE],
    items_mapping_file = mapping,
    control = SSPICE::correction_control(
      seed = 123L, max_iterations = 20L, use_parallel = FALSE
    )
  )
  print(result$corrected_data)
  print(result$record_summary)
  print(result$unresolved_records)
  stopifnot(identical(result$corrected_data$ID, prepared$data$ID[3]))
  # Resolution is read from the final checks, not assumed from termination.
  print(result$final_routing_check$full_report)
})

