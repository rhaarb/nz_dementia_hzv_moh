# Code and Software Submission Checklist

Corresponding author(s): Richard Haarburger (rhaarb@stanford.edu), Pascal Geldsetzer (pgeldsetzer@stanford.edu)

## Required Content

### Compiled standalone software and/or source code

Provided as source code in this repository.

Relevant folders:

- `Code/00_inputs`
- `Code/01_TableConstruction`
- `Code/02_Analysis`
- `minimal_event_count_check`

### Small dataset for code checking

Provided via the non-sensitive canonical code-list inputs in `Code/00_inputs`.

The planned low-fidelity synthetic dataset is described in `docs/synthetic_data.md`. It will be added by the end of May 2026 and included only to demonstrate that the analysis code is executable without access to the sensitive Ministry of Health data. It will not reproduce the quantitative manuscript results.

Check command:

```r
Rscript "minimal_event_count_check/run_check.R"
```

The full study data cannot be shared because it contains sensitive New Zealand Ministry of Health individual-level data.

### README file

Provided in `README.md`, with additional details in:

- `docs/data_boundary.md`
- `docs/dependencies.md`
- `docs/synthetic_data.md`
- `minimal_event_count_check/README.md`
- `Code/01_TableConstruction/README.md`

## README Contents

### 1. System requirements

Operating system for public minimal event-count check test: macOS Darwin 25.4.0, arm64.

Software dependencies: listed in `docs/dependencies.md`.

Non-standard hardware: none expected for the public minimal event-count check. Full study replication requires access to the secure data environment containing the sensitive study data.

### 2. Installation guide

Install R and the packages listed in `docs/dependencies.md`, then clone or download this repository.

Typical install time: approximately 10-30 minutes on a normal desktop computer, depending on whether binary R packages are available for the operating system.

### 3. Minimal Event-Count Check

Instructions: see `minimal_event_count_check/README.md`.

Expected output: `outputs/minimal_event_count_check/canonical_input_summary.csv`, plus printed confirmation of canonical input event and row counts. For the full analysis, the expected output is a rendered version of `Code/02_Analysis/09_analysis.rmd`, included as `Code/02_Analysis/09_analysis.html`, together with the tables and figures written to `outputs/Tables`.

Expected run time: less than one second on a normal desktop computer for the minimal event-count check. Runtime for the planned synthetic-data code check will be longer and will depend on the final synthetic dataset and analysis workflow.

### 4. Instructions for use

Full run order is described in `README.md` and `Code/01_TableConstruction/README.md`.

The full preprocessing and analysis pipeline requires the sensitive study data and should be run only on the secure data machine.

The public minimal event-count check runs in less than one second. On the study analysis system, the full analysis markdown takes approximately 7 days when bootstrap outputs are regenerated. When bootstrap sections are skipped or previously generated bootstrap outputs are reused, the analysis markdown takes approximately 2 hours. Exact runtime depends on the secure analysis environment and available cores.

## Additional Information

### License

MIT License. See `LICENSE`.
