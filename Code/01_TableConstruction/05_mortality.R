source("Code/01_TableConstruction/00_functions.R")

moscoded <- read_pipe_files("mos.*_coded") %>%
  mutate(DOD = as.Date(DOD, format = "%d/%m/%Y"))

icd10_master <- readRDS(project_path("Code/00_inputs/canonical_icd_codes.rds")) %>%
  filter(EVENT != "")

retrieve_unique_nhi <- function(data, code_prefix, codes) {
  data %>%
    rowwise() %>%
    mutate(any_flag = any(c_across(starts_with(code_prefix)) %in% codes)) %>%
    ungroup() %>%
    filter(any_flag) %>%
    pull(new_enc_nhi) %>%
    unique()
}

icd_groups <- c("icdd", "icdf", "icdg", "icdc")

for (event in unique(icd10_master$EVENT)) {
  message("Writing mortality flags for event: ", event)

  icd_codes <- icd10_master %>%
    filter(EVENT == event) %>%
    pull(CODE)

  event_nhi_by_group <- setNames(
    lapply(icd_groups, function(group) retrieve_unique_nhi(moscoded, group, icd_codes)),
    icd_groups
  )

  all_event_nhi <- unique(unlist(event_nhi_by_group))

  moscoded <- moscoded %>%
    mutate(!!paste0(event, "_flag") := if_else(new_enc_nhi %in% all_event_nhi, 1, 0))

  for (group in icd_groups) {
    moscoded <- moscoded %>%
      mutate(!!paste0(event, "_", group, "_flag") := if_else(new_enc_nhi %in% event_nhi_by_group[[group]], 1, 0))
  }
}

qs_save_nonempty(moscoded, processed_output_path("mortality/moscoded_flagged.qs"))

mosuncoded <- read_pipe_files("mos.*_uncoded")

death_cause_cols <- names(mosuncoded)[startsWith(names(mosuncoded), "BDM_DEATH_CAUSE_")]

mosuncoded_flagged <- mosuncoded %>%
  mutate(
    dementia_narrow_def_icdd_flag = if_else(grepl("DEMENTIA", BDM_DEATH_CAUSE_1, ignore.case = TRUE), 1, 0),
    dementia_narrow_def_flag = if_else(rowSums(sapply(select(., all_of(death_cause_cols)), grepl, pattern = "DEMENTIA", ignore.case = TRUE)) > 0, 1, 0),
    DOD = as.Date(DOD, format = "%d/%m/%Y"),
    CC_SYS = NA,
    POST_MORTEM_CODE = NA,
    PRESCRIPTIONDRUG_INV = NA,
    WORK_RELATED_IND = NA,
    icdd = NA,
    icdf1 = NA,
    dementia_narrow_def_icdf_flag = NA,
    dementia_narrow_def_icdg_flag = NA,
    dementia_narrow_def_icdc_flag = NA
  ) %>%
  select(
    new_enc_nhi = new_master_nhi, REG_YEAR, DOD, AGE_AT_DEATH_YRS,
    DEATH_TYPE_CODE, CC_SYS, POST_MORTEM_CODE, PRESCRIPTIONDRUG_INV,
    WORK_RELATED_IND, icdd, icdf1, dementia_narrow_def_flag, dementia_narrow_def_icdd_flag,
    dementia_narrow_def_icdf_flag, dementia_narrow_def_icdg_flag, dementia_narrow_def_icdc_flag
  )

moscoded_w_msuncoded <- bind_rows(moscoded, mosuncoded_flagged)

qs_save_nonempty(moscoded_w_msuncoded, processed_output_path("mortality/moscoded_w_msuncoded_flagged.qs"))
