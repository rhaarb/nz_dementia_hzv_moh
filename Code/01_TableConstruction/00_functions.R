library(dplyr)
library(qs)
library(readr)
library(tidyr)
library(purrr)

baseline_date <- as.Date("2018-04-01")
one_year_pre_date <- as.Date("2017-04-01")

project_path <- function(...) {
  file.path(getwd(), ...)
}

processed_input_path <- function(...) {
  file.path(getwd(), Sys.getenv("PROCESSED_INPUT_DIR", "Processed_df"), ...)
}

processed_output_path <- function(...) {
  file.path(getwd(), Sys.getenv("PROCESSED_OUTPUT_DIR", "Processed_df"), ...)
}

search_files <- function(keyword, folder_path = getwd()) {
  files <- list.files(path = folder_path, pattern = paste0(keyword, ".*\\.txt$"), full.names = TRUE)
  if (length(files) == 0) {
    stop("No files matched pattern: ", keyword, " in ", folder_path, call. = FALSE)
  }
  files
}

read_pipe_files <- function(keyword, folder_path = getwd(), nrows = -1, as_character = FALSE, ...) {
  files <- search_files(keyword, folder_path)
  reader <- function(path) {
    read.table(path, sep = "|", header = TRUE, fill = TRUE, na.strings = "", nrows = nrows, ...)
  }
  out <- map(files, reader)
  if (as_character) {
    out <- lapply(out, function(df) mutate_all(df, as.character))
  }
  bind_rows(out)
}

ensure_dir <- function(path) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
}

qs_save_nonempty <- function(data, file_path) {
  ensure_dir(dirname(file_path))
  if (nrow(data) == 0) {
    warning("Skipping empty output: ", file_path, call. = FALSE)
    return(invisible(FALSE))
  }
  qsave(data, file_path)
  invisible(TRUE)
}

make_vaccine_event_table <- function(immunisation, vaccine) {
  immunisation %>%
    filter(VACCINE == vaccine) %>%
    select(new_enc_nhi, VACCINATION_DATE) %>%
    arrange(new_enc_nhi, VACCINATION_DATE) %>%
    group_by(new_enc_nhi) %>%
    mutate(row = row_number()) %>%
    ungroup() %>%
    pivot_wider(names_from = row, values_from = VACCINATION_DATE, names_prefix = paste0(vaccine, "_"))
}

make_hospital_event_table <- function(event, icd_codes, hospital_diag, hospital_event) {
  event_codes <- icd_codes %>%
    filter(EVENT == event) %>%
    pull(CODE) %>%
    unique()

  event_ids <- hospital_diag %>%
    filter(CLIN_CD %in% event_codes) %>%
    pull(EVENT_ID) %>%
    unique()

  hospital_event %>%
    filter(EVENT_ID %in% event_ids) %>%
    select(new_enc_nhi, EVENDATE) %>%
    arrange(new_enc_nhi, EVENDATE) %>%
    group_by(new_enc_nhi) %>%
    mutate(
      row = row_number(),
      !!paste0(event, "_counts") := n(),
      !!paste0(event, "_counts_at_baseline") := sum(EVENDATE < baseline_date, na.rm = TRUE),
      !!paste0(event, "_counts_1_year_pre") := sum(EVENDATE > one_year_pre_date & EVENDATE < baseline_date, na.rm = TRUE)
    ) %>%
    ungroup() %>%
    pivot_wider(names_from = row, values_from = EVENDATE, names_prefix = paste0(event, "_"))
}

make_drug_event_table <- function(event, formulation_codes, pharmaceutical, dispensingevent) {
  event_formulations <- formulation_codes %>%
    filter(output_event == event) %>%
    pull(FORMULATION_ID) %>%
    unique()

  event_keys <- pharmaceutical %>%
    mutate(FORMULATION_ID = as.character(FORMULATION_ID)) %>%
    filter(FORMULATION_ID %in% event_formulations) %>%
    pull(DIM_FORM_PACK_SUBSIDY_KEY) %>%
    unique()

  output_label <- formulation_codes %>%
    filter(output_event == event) %>%
    pull(TG_NAME2) %>%
    unique()

  if (length(output_label) != 1) {
    stop("Expected exactly one TG_NAME2 label for output_event: ", event, call. = FALSE)
  }

  dispensingevent %>%
    filter(DIM_FORM_PACK_SUBSIDY_KEY %in% event_keys) %>%
    select(new_enc_nhi, DATE_DISPENSED) %>%
    arrange(new_enc_nhi, DATE_DISPENSED) %>%
    group_by(new_enc_nhi) %>%
    summarise(
      DATE_DISPENSED = min(DATE_DISPENSED, na.rm = TRUE),
      !!paste0(output_label, "_counts") := n(),
      !!paste0(output_label, "_counts_at_baseline") := sum(DATE_DISPENSED < baseline_date, na.rm = TRUE),
      !!paste0(output_label, "_counts_1_year_pre") := sum(DATE_DISPENSED > one_year_pre_date & DATE_DISPENSED < baseline_date, na.rm = TRUE),
      .groups = "drop"
    )
}

make_zoster_drug_event_table <- function(event, formulation_codes, pharmaceutical, dispensingevent) {
  event_formulations <- formulation_codes %>%
    filter(output_event == event) %>%
    pull(FORMULATION_ID) %>%
    unique()

  event_keys <- pharmaceutical %>%
    mutate(FORMULATION_ID = as.character(FORMULATION_ID)) %>%
    filter(FORMULATION_ID %in% event_formulations) %>%
    pull(DIM_FORM_PACK_SUBSIDY_KEY) %>%
    unique()

  output_label <- formulation_codes %>%
    filter(output_event == event) %>%
    pull(TG_NAME2) %>%
    unique()

  dispensingevent %>%
    filter(DIM_FORM_PACK_SUBSIDY_KEY %in% event_keys) %>%
    select(new_enc_nhi, DATE_DISPENSED) %>%
    arrange(new_enc_nhi, DATE_DISPENSED) %>%
    group_by(new_enc_nhi) %>%
    mutate(
      row = row_number(),
      !!paste0(output_label, "_counts") := n(),
      !!paste0(output_label, "_counts_at_baseline") := sum(DATE_DISPENSED < baseline_date, na.rm = TRUE),
      !!paste0(output_label, "_counts_1_year_pre") := sum(DATE_DISPENSED > one_year_pre_date & DATE_DISPENSED < baseline_date, na.rm = TRUE)
    ) %>%
    ungroup() %>%
    pivot_wider(names_from = row, values_from = DATE_DISPENSED, names_prefix = paste0(output_label, "_"))
}

drug_output_file <- function(event, formulation_codes) {
  output_file <- formulation_codes %>%
    filter(output_event == event) %>%
    pull(output_file) %>%
    unique()

  if (length(output_file) != 1) {
    stop("Expected exactly one output_file for output_event: ", event, call. = FALSE)
  }
  output_file
}
