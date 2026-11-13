## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ----standalone-item-mapping, eval=TRUE---------------------------------------
local({
  folder <- tempfile("sspice-mapping-guide-")
  dir.create(folder)
  on.exit(unlink(folder, recursive = TRUE), add = TRUE)
  mapping_file <- file.path(folder, "items_mapping.csv")
  observed <- c(10, 21, 99)
  expected <- sort(c("4|DETAIL|-1", "5|DETAIL|1", "6|DETAIL|-1"))

  for (structural in list(c(10, 20, 30), 1:3)) {
    mapping <- data.frame(
      varname = "CHOICE", item_route = structural,
      item_dataset = observed
    )
    utils::write.csv(mapping, mapping_file, row.names = FALSE)

    routes <- data.frame(
      V1 = c("ID", "CHOICE", "DETAIL", "END"),
      V2 = c(1, 3, 1, 1),
      V3 = c(1, min(structural), 1, 1),
      V4 = c(9999, max(structural), 1, 1),
      V5 = 0, V6 = c(0, 1, 0, 0),
      V7 = c(NA, structural[2], NA, NA),
      V8 = c(NA, "END", NA, NA)
    )
    dag <- SSPICE::build_DAG(routes, analyze = FALSE)
    original <- data.frame(
      ID = 1:6, CHOICE = rep(observed, 2),
      DETAIL = c(1, NA, 1, NA, 1, NA), END = 1
    )
    prepared <- SSPICE::prepare_data(original, dag)$data
    stopifnot(isTRUE(all.equal(prepared$CHOICE, original$CHOICE)))

    checked <- SSPICE::routing_check(
      prepared, dag$routes_numeric, dag$Bt, "ID",
      basename(mapping_file), dirname(mapping_file)
    )
    report <- checked$full_report
    keys <- sort(paste(report$ID, report$varname_label,
                       report$errcode, sep = "|"))
    stopifnot(identical(keys, expected))
    cat("\nStructural codes:", structural, "\n")
    print(report[, c("ID", "varname_label", "errcode", "routeval")])

    corrected <- SSPICE::correct_data(
      prepared[4:6, , drop = FALSE], dag, record_id = "ID",
      donor_data = prepared[1:3, , drop = FALSE],
      immutable_variables = c("CHOICE", "END"),
      items_mapping_file = mapping_file,
      control = SSPICE::correction_control(
        seed = 123L, max_iterations = 12L, use_parallel = FALSE
      )
    )
    stopifnot(
      isTRUE(all.equal(corrected$corrected_data$DETAIL, c(1, NA, 1))),
      isTRUE(all.equal(corrected$corrected_data$CHOICE, observed)),
      all(corrected$record_summary$resolved)
    )
    print(corrected$corrected_data)

    # These internal generators are also used by the operational scripts.
    # getFromNamespace is explicit: they are not exported public functions.
    rules <- getFromNamespace("create_rules", "SSPICE")(
      dag$Bt, dag$routes_numeric,
      basename(mapping_file), dirname(mapping_file)
    )
    expected_rules <- c(
      "CHOICE(10) DETAIL< )",
      "CHOICE(21) DETAIL() END< )",
      "CHOICE(99) DETAIL< )"
    )
    stopifnot(setequal(rules[startsWith(rules, "CHOICE(")], expected_rules))
    print(rules[startsWith(rules, "CHOICE(")])
    vardom <- getFromNamespace("create_vardom", "SSPICE")(
      dag$routes_numeric, dag$Bt,
      basename(mapping_file), dirname(mapping_file)
    )$vardom
    choice_domain <- vardom[vardom$varname == "CHOICE", , drop = FALSE]
    stopifnot(identical(as.character(choice_domain$intervalli),
      paste0(sprintf("%04d%04d", observed, observed), collapse = "")))
    print(choice_domain)
  }
})

## ----verify-mapping-project, eval=FALSE---------------------------------------
# source("scripts/13_verify_item_mapping.R")

