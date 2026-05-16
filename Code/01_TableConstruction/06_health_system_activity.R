source("Code/01_TableConstruction/00_functions.R")

dispensingevent <- qread(processed_input_path("dispensingevent.qs"))
publichosevent <- qread(processed_input_path("publichosevent.qs"))
privatehosevent <- qread(processed_input_path("privatehosevent.qs"))

dispensing_summary <- dispensingevent %>%
  distinct(new_enc_nhi)

publichos_summary <- publichosevent %>%
  distinct(new_enc_nhi)

privatehos_summary <- privatehosevent %>%
  distinct(new_enc_nhi)

combined_patient_list <- bind_rows(dispensing_summary, publichos_summary, privatehos_summary) %>%
  distinct()

ensure_dir(processed_output_path())
saveRDS(combined_patient_list, processed_output_path("combined_patient_list.RDS"))

latest_dispense <- dispensingevent %>%
  group_by(new_enc_nhi) %>%
  summarise(most_recent_date = max(DATE_DISPENSED, na.rm = TRUE), .groups = "drop")

latest_pubhos_event <- publichosevent %>%
  group_by(new_enc_nhi) %>%
  summarise(most_recent_date = max(EVENDATE, na.rm = TRUE), .groups = "drop")

latest_privhos_event <- privatehosevent %>%
  group_by(new_enc_nhi) %>%
  summarise(most_recent_date = max(EVENDATE, na.rm = TRUE), .groups = "drop")

combined_most_recent_event_list <- bind_rows(latest_dispense, latest_pubhos_event, latest_privhos_event) %>%
  group_by(new_enc_nhi) %>%
  summarise(most_recent_date = max(most_recent_date, na.rm = TRUE), .groups = "drop") %>%
  filter(!is.na(most_recent_date)) %>%
  distinct()

saveRDS(combined_most_recent_event_list, processed_output_path("combined_most_recent_event_list.RDS"))
saveRDS(latest_pubhos_event, processed_output_path("latest_pubhos_event.RDS"))
saveRDS(latest_privhos_event, processed_output_path("latest_privhos_event.RDS"))
saveRDS(latest_dispense, processed_output_path("latest_dispense.RDS"))
