## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", eval = FALSE)

## ----metadata-check-----------------------------------------------------------
# source(file.path("scripts", "00_config.R"))
# stopifnot(all(file.exists(c(config$routing_file, config$vaux_file,
#                             config$logical_edit_rules_file,
#                             config$items_mapping_file))))
# utils::head(utils::read.csv(config$items_mapping_file, check.names = FALSE))

## ----vaux-case-study, eval=FALSE----------------------------------------------
# # Run from the root of your project copy.
# d <- readRDS("output/prepared-data/prepared_questionnaire_data.rds")
# table(d$VAUX7, useNA = "ifany")
# table(d$VAUX_PROP2, useNA = "ifany")

## ----standalone-ledit, eval=TRUE----------------------------------------------
local({
  edits <- read.table(text = paste(
    "LEDIT_TOTAL;2;A;;;BLANK;;;AND",
    "LEDIT_TOTAL;2;B;;;BLANK;;;NULL",
    "LEDIT_TOTAL;1;A;;;;;;+",
    "LEDIT_TOTAL;1;B;;;;;;=100", sep = "\n"),
    sep = ";", header = FALSE, colClasses = "character",
    na.strings = character(0))
  x <- data.frame(ID = 1:5, A = c(40, NA, 40, 100, NA),
                  B = c(60, NA, 50, NA, 20))
  create_edits <- getFromNamespace("create_logical_edit_variables", "SSPICE")
  out <- create_edits(x, edits)
  print(out)
  stopifnot(identical(out$LEDIT_TOTAL, c(1, 2, NA_real_, 1, NA_real_)))
  print(attr(out, "logical_edit_definitions"))
})

