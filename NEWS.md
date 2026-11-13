# SSPICE 0.1.0 (CRAN resubmission)

* Removed direct assignment to `.GlobalEnv` in record correction. Per-record
  seeds now use `withr` scopes that restore the caller's RNG state and kind,
  including on errors. Seeds remain deterministic across workers and batches.
* Replaced superassignment in routing diagnostics, logical-edit repair and
  admissible-pattern counting with explicit, per-call local environments.
* Random sequences differ from the previous submission. Checkpoint fingerprints
  now include the RNG scheme version, preventing reuse of old checkpoints.
* Added an internal null-default operator for compatibility with the declared
  R >= 4.2 requirement (the base operator is only available from R 4.4).
