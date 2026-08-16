#!/usr/bin/env Rscript

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(quarto, here)

eval_qmd_path <- here::here("indicator_analysis", "indicator_evaluation.qmd")
comp_qmd_path <- here::here("indicator_analysis", "indicator_correlation.qmd")
multi_comp_qmd_path <- here::here("indicator_analysis", "indicator_multi_comparison.qmd")
rev_qmd_path <- here::here("revision_analysis", "revision_analysis.qmd")

# 1. State Comparison: HHS vs Doctor Visits
out_comp_state <- here::here("indicator_analysis", "comp_hhs_vs_doctor_visits_api_state.html")
if (!file.exists(out_comp_state)) {
  message(sprintf("Generating missing report: %s", out_comp_state))
  quarto::quarto_render(
    input = comp_qmd_path,
    output_file = "comp_hhs_vs_doctor_visits_api_state.html",
    execute_params = list(
      guiding_source = "hhs",
      guiding_indicator = "confirmed_admissions_covid_1d",
      guiding_name = "COVID Hospital Admissions (HHS)",
      candidate_source = "doctor-visits",
      candidate_indicator = "smoothed_adj_cli",
      candidate_name = "Doctor Visits: Smoothed Adj CLI",
      geo_type = "state",
      time_type = "day",
      start_day = "2020-09-01",
      end_day = "2023-03-01"
    )
  )
} else {
  message("Skipping existing report: comp_hhs_vs_doctor_visits_api_state.html")
}

# 2. State Multi-Reference Comparison: Doctor Visits
out_multi_comp_state <- here::here("indicator_analysis", "indicator_multi_comparison.html")
if (!file.exists(out_multi_comp_state)) {
  message(sprintf("Generating missing report: %s", out_multi_comp_state))
  quarto::quarto_render(
    input = multi_comp_qmd_path,
    output_file = "indicator_multi_comparison.html",
    execute_params = list(
      candidate_source = "doctor-visits",
      candidate_indicator = "smoothed_adj_cli",
      candidate_name = "Doctor Visits: Smoothed Adj CLI",
      reference_sources = c("quidel", "hospital-admissions", "chng", "chng"),
      reference_indicators = c(
        "covid_ag_smoothed_pct_positive",
        "smoothed_covid19_from_claims",
        "7dav_inpatient_covid",
        "7dav_outpatient_covid"
      ),
      reference_names = c(
        "Quidel: Smoothed % Positive COVID Antigen",
        "Hospital Admissions: Smoothed COVID-19 from Claims",
        "CHNG: 7-day Avg Inpatient COVID",
        "CHNG: 7-day Avg Outpatient COVID"
      ),
      geo_type = "state",
      time_type = "day",
      start_day = "2020-09-01",
      end_day = "2023-03-01"
    )
  )
} else {
  message("Skipping existing report: indicator_multi_comparison.html")
}

# 3. State Candidate EDA: Doctor Visits
out_eval_state <- here::here("indicator_analysis", "eval_doctor_visits_smoothed_adj_cli_api_state.html")
if (!file.exists(out_eval_state)) {
  message(sprintf("Generating missing report: %s", out_eval_state))
  quarto::quarto_render(
    input = eval_qmd_path,
    output_file = "eval_doctor_visits_smoothed_adj_cli_api_state.html",
    execute_params = list(
      source = "doctor-visits",
      signal = "smoothed_adj_cli",
      name = "Doctor Visits: Smoothed Adj CLI",
      geo_type = "state",
      time_type = "day",
      start_day = "2020-09-01",
      end_day = "2023-03-01"
    )
  )
} else {
  message("Skipping existing report: eval_doctor_visits_smoothed_adj_cli_api_state.html")
}

# 4. County Comparison: JHU CSSE vs Doctor Visits
out_county_comp <- here::here("indicator_analysis", "eval_jhu_csse_vs_doctor_visits_api_county.html")
if (!file.exists(out_county_comp)) {
  message(sprintf("Generating missing report: %s", out_county_comp))
  quarto::quarto_render(
    input = comp_qmd_path,
    output_file = "eval_jhu_csse_vs_doctor_visits_api_county.html",
    execute_params = list(
      guiding_source = "jhu-csse",
      guiding_indicator = "confirmed_incidence_num",
      guiding_name = "JHU COVID-19 Cases",
      candidate_source = "doctor-visits",
      candidate_indicator = "smoothed_adj_cli",
      candidate_name = "Doctor Visits: Smoothed Adj CLI",
      geo_type = "county",
      time_type = "day",
      start_day = "2023-01-01",
      end_day = "2023-02-01"
    )
  )
} else {
  message("Skipping existing report: eval_jhu_csse_vs_doctor_visits_api_county.html")
}

# 5. County Candidate EDA: Doctor Visits
out_county_eval <- here::here("indicator_analysis", "eval_doctor_visits_smoothed_adj_cli_api_county.html")
if (!file.exists(out_county_eval)) {
  message(sprintf("Generating missing report: %s", out_county_eval))
  quarto::quarto_render(
    input = eval_qmd_path,
    output_file = "eval_doctor_visits_smoothed_adj_cli_api_county.html",
    execute_params = list(
      source = "doctor-visits",
      signal = "smoothed_adj_cli",
      name = "Doctor Visits: Smoothed Adj CLI",
      geo_type = "county",
      time_type = "day",
      start_day = "2023-01-01",
      end_day = "2023-02-01"
    )
  )
} else {
  message("Skipping existing report: eval_doctor_visits_smoothed_adj_cli_api_county.html")
}

# 6. Revision Analysis: Hospital Admissions State
out_rev_state <- here::here("revision_analysis", "revision_hospital_admissions_smoothed_covid19_from_claims_api_state.html")
if (!file.exists(out_rev_state)) {
  message(sprintf("Generating missing report: %s", out_rev_state))
  quarto::quarto_render(
    input = rev_qmd_path,
    output_file = "revision_hospital_admissions_smoothed_covid19_from_claims_api_state.html",
    execute_params = list(
      source = "hospital-admissions",
      signal = "smoothed_covid19_from_claims",
      signal_name = "Hospital Admissions: Smoothed COVID-19 from Claims",
      input_dir = "revision_analysis/data/revisions",
      geo_type = "state",
      time_type = "day",
      start_day = "2020-01-01",
      end_day = "2023-12-31"
    )
  )
} else {
  message("Skipping existing report: revision_hospital_admissions_smoothed_covid19_from_claims_api_state.html")
}

# 7. Nickel: Diarrhea Care-Setting Signals (ED / IP / OP)
nickel_outputs <- here::here("examples", "nickel", c("eval_diarrhea_ed.html", "eval_diarrhea_ip.html", "eval_diarrhea_op.html"))
if (!all(file.exists(nickel_outputs))) {
  message("Generating missing Nickel diarrhea reports")
  source(here::here("examples", "nickel", "nickel_statistical_analysis.R"))
} else {
  message("Skipping existing Nickel diarrhea reports")
}

# 8. Sleep Cycle: Combined Cough Signals (State & County)
sleepcycle_outputs <- here::here("examples", "sleepcycle", c("sleepcycle_all_state.html", "sleepcycle_all_county.html"))
if (!all(file.exists(sleepcycle_outputs))) {
  message("Generating missing Sleep Cycle cough signal reports")
  source(here::here("examples", "sleepcycle", "sleepcycle-analysis.R"))
} else {
  message("Skipping existing Sleep Cycle cough signal reports")
}

# 9. VA: COVID Cases/100k (State & MSA)
va_outputs <- here::here("examples", "va", c("state_ci.html", "msa_ci.html"))
if (!all(file.exists(va_outputs))) {
  message("Generating missing VA COVID Cases/100k reports")
  source(here::here("examples", "va", "va-analysis.R"))
} else {
  message("Skipping existing VA COVID Cases/100k reports")
}
