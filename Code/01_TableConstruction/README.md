# Clean table-construction scripts

Run these scripts from the project root on the secure data machine.

By default, scripts read from and write to `Processed_df`. To write generated outputs to a separate folder, set:

```r
Sys.setenv(PROCESSED_INPUT_DIR = "Processed_df")
Sys.setenv(PROCESSED_OUTPUT_DIR = "Processed_df_clean")
```

The same environment variables can also be set in the shell before calling `Rscript`.

These scripts assume the raw cohort, immunisation, and mortality text files are available in the project root, matching the search patterns used by `read_pipe_files()`:

- `_mis*.txt`
- `imm_event*.txt`
- `mos*_coded*.txt`
- `mos*_uncoded*.txt`

They also assume the raw-derived intermediate `.qs` files already exist:

- `Processed_df/publichosdiag.qs`
- `Processed_df/publichosevent.qs`
- `Processed_df/privatehosdiag.qs`
- `Processed_df/privatehosevent.qs`
- `Processed_df/dispensingevent.qs`
- `Processed_df/pharmaceutical.qs`

They use the canonical code-list inputs in `Code/00_inputs` and write the analysis-facing event `.qs` files expected by `Code/02_Analysis/09_analysis.rmd`.

## Execution order

```r
Rscript "Code/00_inputs/build_canonical_inputs.R"
Rscript "Code/01_TableConstruction/01_cohort_vaccines.R"
Rscript "Code/01_TableConstruction/02_public_hospital.R"
Rscript "Code/01_TableConstruction/03_private_hospital.R"
Rscript "Code/01_TableConstruction/04_pharmaceutical.R"
Rscript "Code/01_TableConstruction/05_mortality.R"
Rscript "Code/01_TableConstruction/06_health_system_activity.R"
```
