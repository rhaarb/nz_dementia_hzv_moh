# Dependencies

Package versions should be recorded from the analysis environment before submission.

## Required Software

The code requires R. The public minimal event-count check was tested with:

```text
Operating system: macOS Darwin 25.4.0, arm64
R version: R 4.5.3
```

## R Packages

The preprocessing and analysis scripts use the following packages. The versions below are the versions available in the local test environment used for the public minimal event-count check and code parsing. Package versions for the full analysis environment should be recorded in `docs/session_info.txt`.

| Package | Local test version |
| --- | --- |
| tidyverse | 2.0.0 |
| data.table | 1.18.2.1 |
| ggpubr | 0.6.3 |
| ggfixest | 0.4.0 |
| grid | R base/recommended |
| gridExtra | 2.3 |
| forestploter | 1.1.3 |
| DiagrammeR | 1.0.11 |
| DiagrammeRsvg | 0.1 |
| rsvg | 2.7.0 |
| scales | 1.4.0 |
| rdrobust | 3.0.0 |
| RDHonest | 1.0.1 |
| rdhte | 0.1.0 |
| fixest | 0.14.0 |
| survival | 3.8.6 |
| mgcv | 1.9.4 |
| prodlim | 2026.3.11 |
| splines | R base/recommended |
| survminer | 0.5.2 |
| cmprsk | 2.2.12 |
| table1 | 1.5.1 |
| flextable | 0.9.11 |
| officer | 0.7.3 |
| dplyr | 1.2.1 |
| qs | Required for full pipeline; not required for public minimal event-count check |
| readr | 2.2.0 |
| tidyr | 1.3.2 |
| purrr | 1.2.1 |

## Recording Analysis Environment Versions

Run this command from the repository root in the analysis environment:

```r
Rscript "Code/99_capture_session_info.R"
```

This writes `docs/session_info.txt`, which records the operating system, R version, loaded package versions, and namespace versions.
