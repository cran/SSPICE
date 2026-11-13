## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## ----routing-examples---------------------------------------------------------
make_routes <- function(lines) {
  read.table(text = paste(lines, collapse = "\n"),
             sep = ";", header = FALSE,
             na.strings = ".", stringsAsFactors = FALSE)
}
r <- make_routes(c(
  "SCELTA;2;1;2;0;1;1;FINE",
  "DETTAGLIO;1;0;100;0;0;.;.",
  "FINE;1;1;1;0;0;.;."
))
dag <- SSPICE::build_DAG(r, analyze = FALSE)
stopifnot(isTRUE(dag$graph_diagnostics$is_DAG))
dag$Bt

absolute <- r
absolute$V6[1] <- 98L
absolute$V7[1] <- NA
absolute$V8[1] <- "FINE"
dag_absolute <- SSPICE::build_DAG(absolute, analyze = FALSE)
stopifnot(all(dag_absolute$Bt[1:2, "FINE"] == -1),
          all(dag_absolute$Bt[1:2, "DETTAGLIO"] == 0))
dag_absolute$Bt

or_routes <- make_routes(c(
  "INIZIO;1;1;1;0;0;.;.",
  "MEZZO_A;1;1;1;1;0;.;.",
  "MEZZO_B;1;1;1;1;0;.;.",
  "FINE;1;1;1;0;0;.;."
))
dag_or <- SSPICE::build_DAG(or_routes, analyze = FALSE)
stopifnot("VOR1" %in% dag_or$varnames)
dag_or$routes_grouped

xor_routes <- make_routes(c(
  "INIZIO;1;1;1;0;0;.;.",
  "NESSUNA_SPESA;1;1;1;-1;98;.;FINE",
  "IMPORTO;1;0;100000;-1;0;.;.",
  "DETTAGLIO;2;1;2;0;0;.;.",
  "FINE;1;1;1;0;0;.;."
))
dag_xor <- SSPICE::build_DAG(xor_routes, analyze = FALSE)
stopifnot("VXOR1" %in% dag_xor$varnames)
dag_xor$routes_grouped

