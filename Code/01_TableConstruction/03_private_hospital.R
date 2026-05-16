source("Code/01_TableConstruction/00_functions.R")

icd_codes <- readRDS(project_path("Code/00_inputs/canonical_icd_codes.rds"))
privatehosdiag <- qread(processed_input_path("privatehosdiag.qs"))
privatehosevent <- qread(processed_input_path("privatehosevent.qs"))

events <- icd_codes %>%
  pull(EVENT) %>%
  unique()

for (event in events) {
  message("Writing private hospital event: ", event)
  result <- make_hospital_event_table(event, icd_codes, privatehosdiag, privatehosevent)
  qs_save_nonempty(result, processed_output_path("privatehospital", paste0(event, ".qs")))
}
