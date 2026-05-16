source("Code/01_TableConstruction/00_functions.R")

cohort <- read_pipe_files("_mis") %>%
  mutate(
    DOB = as.Date(DOB, format = "%d/%m/%Y"),
    DOD = as.Date(DOD, format = "%d/%m/%Y"),
    DOB = if_else(DOB < as.Date("1900-01-01"), as.Date("1900-01-01"), DOB)
  )

qs_save_nonempty(cohort, processed_output_path("cohort.qs"))

immunisation <- read_pipe_files("imm_event", as_character = TRUE) %>%
  rename(new_enc_nhi = NEW_ENCRYPTED_HCU_ID) %>%
  mutate(
    VACCINATION_DATE = as.Date(VACCINATION_DATE, format = "%Y-%m-%d"),
    VACCINE = if_else(VACCINATION_DATE < as.Date("2022-12-01") & VACCINE == "rZV", "old_rZV", VACCINE)
  ) %>%
  arrange(new_enc_nhi, VACCINE, VACCINATION_DATE)

immunisation_counts <- immunisation %>%
  count(new_enc_nhi, VACCINE, name = "count") %>%
  pivot_wider(names_from = VACCINE, values_from = count, values_fill = list(count = 0))

qs_save_nonempty(immunisation_counts, processed_output_path("vaccine/immunisation_counts.qs"))

vaccine_names <- sort(unique(immunisation$VACCINE))

for (vaccine in vaccine_names) {
  message("Writing vaccine event: ", vaccine)
  result <- make_vaccine_event_table(immunisation, vaccine)
  qs_save_nonempty(result, processed_output_path("vaccine", paste0(vaccine, ".qs")))
}
