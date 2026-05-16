# Canonical preprocessing inputs

This folder contains the consolidated code-list inputs for the replication pipeline.

The source of truth for inclusion is `Code/02_Analysis/09_analysis.rmd`: if the final analysis script loads a hospital or pharmaceutical `.qs` file, its event label should appear in one of the canonical files here.

## Files

- `canonical_icd_codes.csv` / `canonical_icd_codes.rds`
  - One consolidated ICD input table for all public and private hospital event outputs loaded by the final analysis script.
  - Includes the hospital event definitions used by the table-construction scripts.

- `canonical_drug_formulations.csv` / `canonical_drug_formulations.rds`
  - One consolidated formulation input table for all pharmaceutical event outputs loaded by the final analysis script.
  - Uses `output_event` and `output_file` columns to define the event name and output filename for each pharmaceutical event table.

- `canonical_input_coverage_summary.csv`
  - One row per required hospital/drug event, with the number of canonical rows found.
  - All events should have `covered == TRUE`.

- `build_canonical_inputs.R`
  - Rebuilds the canonical `.rds` files and coverage summary from the tracked canonical `.csv` files.
  - Run from the project root.

## Rebuild command

From the project root:

```r
Rscript "Code/00_inputs/build_canonical_inputs.R"
```
