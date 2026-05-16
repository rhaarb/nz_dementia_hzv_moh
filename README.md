# NZ MOH HZV Dementia Replication Code

This repository contains replication code for the New Zealand herpes zoster vaccination and dementia regression-discontinuity study. The sensitive Ministry of Health source data and generated individual-level datasets are not included.

## 1. System Requirements

### Software dependencies and operating systems

The code requires R and the R packages listed in the installation guide below. The full preprocessing and analysis pipeline must be run in the approved secure data environment containing the Ministry of Health data.

The R version, operating system, and package versions used for the rendered analysis are printed in `Code/02_Analysis/09_analysis.html`.

### Required non-standard hardware

No non-standard hardware is required. Runtime and memory requirements for the full pipeline depend on the secure analysis environment and the size of the Ministry of Health extracts.

## 2. Installation Guide

### Instructions

1. Clone or download this repository.
2. Install R.
3. Install the required R packages:

```r
install.packages(c(
  "tidyverse", "data.table", "ggpubr", "ggfixest", "gridExtra",
  "forestploter", "DiagrammeR", "DiagrammeRsvg", "rsvg", "scales",
  "rdrobust", "RDHonest", "rdhte", "fixest", "survival", "mgcv", "prodlim",
  "survminer", "cmprsk", "table1", "flextable", "officer",
  "dplyr", "qs", "readr", "tidyr", "purrr"
))
```

The `rdhte` package may need to be installed from its source repository if it is not available through CRAN in the analysis environment.

### Typical install time

Typical installation time on a normal desktop computer is approximately 10-30 minutes, depending on whether binary packages are available for the operating system.

## 3. Minimal Event-Count Check

### Instructions to run on data

The check uses only the non-sensitive canonical code-list inputs included in this repository. Run it from the repository root:

```r
Rscript "minimal_event_count_check/run_check.R"
```

### Expected output

```text
Minimal event-count check completed successfully.
ICD events: 39
ICD rows: 3709
Drug events: 23
Drug rows: 1222
Wrote: outputs/minimal_event_count_check/canonical_input_summary.csv
```

The check writes `outputs/minimal_event_count_check/canonical_input_summary.csv`.

For the full analysis, the expected output is a rendered version of `Code/02_Analysis/09_analysis.rmd`, included as `Code/02_Analysis/09_analysis.html`, together with the tables and figures written to `outputs/Tables`. GitHub may not preview the rendered HTML file because of its size; download the file and open it locally in a web browser to view it.

The planned synthetic-data code check is described in `docs/synthetic_data.md`.

### Expected run time

Typical run time for the minimal event-count check on a normal desktop computer is less than one second. Runtime for the planned synthetic-data code check will be longer and will depend on the final synthetic dataset and analysis workflow.

## 4. Instructions For Use

### How to run the software on your data

The full pipeline requires the Ministry of Health data files in the approved secure data environment. The expected data boundary and local folder layout are described in `docs/data_boundary.md`.

By default, the analysis script assumes the working directory is the data/project root and uses:

- `Processed_df` for preprocessed inputs
- `outputs/Tables` for generated tables and figures
- `Code/FUNCTIONS.R` for shared functions

These paths can be overridden without editing the script:

```r
Sys.setenv(NZ_DATA_DIR = "/path/to/project_root")
Sys.setenv(NZ_CODE_DIR = "/path/to/project_root/Code")
Sys.setenv(NZ_OUTPUT_DIR = "/path/to/project_root/outputs/Tables")
```

Run the preprocessing scripts from the repository root:

```r
Rscript "Code/00_inputs/build_canonical_inputs.R"
Rscript "Code/01_TableConstruction/run_event_tables.R"
```

Then render or run:

```text
Code/02_Analysis/09_analysis.rmd
```

### Reproduction instructions

To reproduce the quantitative results in the manuscript, run the preprocessing scripts above to create the analysis-facing files in `Processed_df`, then execute `Code/02_Analysis/09_analysis.rmd` in the same data environment. Generated tables and figures are written to `outputs/Tables` unless `NZ_OUTPUT_DIR` is set.

Some sections of the analysis script run bootstrap procedures. On the study analysis system, the full analysis markdown takes approximately 7 days when bootstrap outputs are regenerated. When bootstrap sections are skipped or previously generated bootstrap outputs are reused, the analysis markdown takes approximately 2 hours. Exact runtime depends on the secure analysis environment and available cores.

## License

This repository is released under the MIT License. See `LICENSE`.
