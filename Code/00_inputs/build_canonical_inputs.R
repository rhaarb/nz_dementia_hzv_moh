library(readr)

project_root <- normalizePath(getwd(), mustWork = TRUE)
inputs_dir <- file.path(project_root, "Code", "00_inputs")

canonical_icd_codes <- read_csv(
  file.path(inputs_dir, "canonical_icd_codes.csv"),
  show_col_types = FALSE,
  col_types = cols(.default = col_character())
)

canonical_drug_formulations <- read_csv(
  file.path(inputs_dir, "canonical_drug_formulations.csv"),
  show_col_types = FALSE,
  col_types = cols(.default = col_character())
)

coverage_summary <- rbind(
  data.frame(
    input_type = "icd",
    event = sort(unique(canonical_icd_codes$EVENT)),
    stringsAsFactors = FALSE
  ),
  data.frame(
    input_type = "drug",
    event = sort(unique(canonical_drug_formulations$output_event)),
    stringsAsFactors = FALSE
  )
)

coverage_summary$n_rows <- c(
  as.integer(table(factor(canonical_icd_codes$EVENT, levels = coverage_summary$event[coverage_summary$input_type == "icd"]))),
  as.integer(table(factor(canonical_drug_formulations$output_event, levels = coverage_summary$event[coverage_summary$input_type == "drug"])))
)
coverage_summary$covered <- coverage_summary$n_rows > 0

saveRDS(canonical_icd_codes, file.path(inputs_dir, "canonical_icd_codes.rds"))
saveRDS(canonical_drug_formulations, file.path(inputs_dir, "canonical_drug_formulations.rds"))
write_csv(coverage_summary, file.path(inputs_dir, "canonical_input_coverage_summary.csv"))

cat("Wrote canonical ICD rows:", nrow(canonical_icd_codes), "\n")
cat("Wrote canonical drug formulation rows:", nrow(canonical_drug_formulations), "\n")
