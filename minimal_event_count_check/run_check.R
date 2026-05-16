output_dir <- file.path("outputs", "minimal_event_count_check")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

icd_path <- file.path("Code", "00_inputs", "canonical_icd_codes.csv")
drug_path <- file.path("Code", "00_inputs", "canonical_drug_formulations.csv")

icd_codes <- read.csv(icd_path, stringsAsFactors = FALSE)
drug_formulations <- read.csv(drug_path, stringsAsFactors = FALSE)

summary_rows <- rbind(
  data.frame(
    input_type = "icd",
    n_events = length(unique(icd_codes$EVENT)),
    n_rows = nrow(icd_codes),
    stringsAsFactors = FALSE
  ),
  data.frame(
    input_type = "drug",
    n_events = length(unique(drug_formulations$output_event)),
    n_rows = nrow(drug_formulations),
    stringsAsFactors = FALSE
  )
)

stopifnot(all(c("EVENT", "CODE") %in% names(icd_codes)))
stopifnot(all(c("output_event", "FORMULATION_ID") %in% names(drug_formulations)))
stopifnot(nrow(icd_codes) > 0)
stopifnot(nrow(drug_formulations) > 0)

write.csv(
  summary_rows,
  file.path(output_dir, "canonical_input_summary.csv"),
  row.names = FALSE
)

cat("Minimal event-count check completed successfully.\n")
cat("ICD events:", summary_rows$n_events[summary_rows$input_type == "icd"], "\n")
cat("ICD rows:", summary_rows$n_rows[summary_rows$input_type == "icd"], "\n")
cat("Drug events:", summary_rows$n_events[summary_rows$input_type == "drug"], "\n")
cat("Drug rows:", summary_rows$n_rows[summary_rows$input_type == "drug"], "\n")
cat("Wrote:", file.path(output_dir, "canonical_input_summary.csv"), "\n")
