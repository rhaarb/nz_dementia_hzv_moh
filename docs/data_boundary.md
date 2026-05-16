# Data Boundary

This repository contains code, documentation, and non-sensitive code-list inputs. It does not contain the sensitive Ministry of Health source data or generated individual-level analysis datasets.

## Included

- R scripts and the final R Markdown analysis script.
- Canonical ICD code and pharmaceutical formulation lists in `Code/00_inputs`.
- Documentation describing the expected pipeline.

## Not Included

- Raw Ministry of Health data files.
- Patient-level `.qs`, `.RDS`, `.rds`, `.csv`, or text outputs derived from sensitive data.
- Bootstrap outputs, rendered tables, figures, and manuscript build products.

## Expected Local Data Layout

On the secure machine, run the repository from a project root containing:

```text
Processed_df/
  cohort.qs
  publichosdiag.qs
  publichosevent.qs
  privatehosdiag.qs
  privatehosevent.qs
  dispensingevent.qs
  pharmaceutical.qs
```

The table-construction scripts also expect raw text files for cohort, immunisation, and mortality construction in the project root, matching these filename patterns:

```text
_mis*.txt
imm_event*.txt
mos*_coded*.txt
mos*_uncoded*.txt
```

The table-construction scripts write analysis-facing outputs back into `Processed_df` by default. For a non-destructive comparison run, set:

```r
Sys.setenv(PROCESSED_INPUT_DIR = "Processed_df")
Sys.setenv(PROCESSED_OUTPUT_DIR = "Processed_df_clean")
```

The final analysis script writes generated tables and figures to `outputs/Tables` unless `NZ_OUTPUT_DIR` is set.
