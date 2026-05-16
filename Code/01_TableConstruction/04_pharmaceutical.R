source("Code/01_TableConstruction/00_functions.R")

formulation_codes <- readRDS(project_path("Code/00_inputs/canonical_drug_formulations.rds"))
dispensingevent <- qread(processed_input_path("dispensingevent.qs"))
pharmaceutical <- qread(processed_input_path("pharmaceutical.qs"))

events <- formulation_codes %>%
  pull(output_event) %>%
  unique()

for (event in events) {
  message("Writing pharmaceutical event: ", event)
  if (event == "Zoster_drug") {
    result <- make_zoster_drug_event_table(event, formulation_codes, pharmaceutical, dispensingevent)
  } else {
    result <- make_drug_event_table(event, formulation_codes, pharmaceutical, dispensingevent)
  }
  qs_save_nonempty(result, processed_output_path("drug", drug_output_file(event, formulation_codes)))
}
