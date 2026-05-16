source("Code/01_TableConstruction/00_functions.R")

icd_codes <- readRDS(project_path("Code/00_inputs/canonical_icd_codes.rds"))
publichosdiag <- qread(processed_input_path("publichosdiag.qs"))
publichosevent <- qread(processed_input_path("publichosevent.qs"))

events <- icd_codes %>%
  pull(EVENT) %>%
  unique()

for (event in events) {
  message("Writing public hospital event: ", event)
  result <- make_hospital_event_table(event, icd_codes, publichosdiag, publichosevent)
  qs_save_nonempty(result, processed_output_path("publichospital", paste0(event, ".qs")))
}
