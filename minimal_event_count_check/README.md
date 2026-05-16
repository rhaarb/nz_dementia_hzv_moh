# Minimal Event-Count Check

This check uses only the non-sensitive canonical code-list inputs included in the repository. It checks that the repository can read the canonical ICD and pharmaceutical formulation files and writes a small summary table.

Run from the repository root:

```r
Rscript "minimal_event_count_check/run_check.R"
```

Expected output:

```text
Minimal event-count check completed successfully.
ICD events: 39
ICD rows: 3709
Drug events: 23
Drug rows: 1222
Wrote: outputs/minimal_event_count_check/canonical_input_summary.csv
```

Typical run time for the minimal event-count check on a normal desktop computer is less than one second.

The full preprocessing and analysis pipeline requires sensitive Ministry of Health data and can only be run on the secure data machine.
