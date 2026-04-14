#!/usr/bin/env Rscript

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(quarto, here)

qmd_path <- here::here("indicator_analysis", "indicator_evaluation.qmd")

# State: HHS vs Dr Visits
out_state <- here::here("indicator_analysis", "eval_hhs_vs_doctor_visits_api_state.html")
if (!file.exists(out_state)) {
  message(sprintf("Generating missing report: %s", out_state))
  quarto::quarto_render(
    input = qmd_path,
    output_file = "eval_hhs_vs_doctor_visits_api_state.html",
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
  message("Skipping existing report: eval_hhs_vs_doctor_visits_api_state.html")
}

# County: JHU CSSE vs Dr Visits
out_county_jhu <- here::here("indicator_analysis", "eval_jhu_csse_vs_doctor_visits_api_county.html")
if (!file.exists(out_county_jhu)) {
  message(sprintf("Generating missing report: %s", out_county_jhu))
  quarto::quarto_render(
    input = qmd_path,
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

# 3. County: Confirmed Incidence vs Dr Visits
out_county_ci <- here::here("indicator_analysis", "eval_confirmed_incidence_num_vs_doctor_visits_api_county.html")
if (!file.exists(out_county_ci)) {
  message(sprintf("Generating missing report: %s", out_county_ci))
  quarto::quarto_render(
    input = qmd_path,
    output_file = "eval_confirmed_incidence_num_vs_doctor_visits_api_county.html",
    execute_params = list(
      guiding_source = "jhu-csse", # Same as above but with legacy file naming
      guiding_indicator = "confirmed_incidence_num",
      guiding_name = "Confirmed Incidence",
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
  message("Skipping existing report: eval_confirmed_incidence_num_vs_doctor_visits_api_county.html")
}

# 4. Revision Analysis: Hospital Admissions State
rev_qmd_path <- here::here("revision_analysis", "revision_analysis.qmd")
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
      input = "revision_analysis/data/revisions",
      geo_type = "state",
      time_type = "day",
      start_day = "2020-01-01",
      end_day = "2023-12-31"
    )
  )
} else {
  message("Skipping existing report: revision_hospital_admissions_smoothed_covid19_from_claims_api_state.html")
}
