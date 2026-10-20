#!/usr/bin/env Rscript

# Load necessary libraries
if (!require("pacman")) install.packages("pacman")
pacman::p_load(vroom, dplyr, readr, stringr, fs, quarto, here, rlang)

qmd_path <- here::here("revision_analysis/revision_analysis.qmd")

# Helper to generate output names
get_output_name <- function(params, suffix = "") {
  name <- sprintf("revision_%s_%s%s.html", params$source, params$signal, suffix)
  stringr::str_replace_all(name, "[[:space:]-]", "_")
}

# Example: confirmed_admissions_covid_ew
params_nhsn <- list(
  source = "nhsn",
  signal = "confirmed_admissions_covid_ew",
  signal_name = "NHSN: Confirmed Admissions COVID Weekly",
  geo_type = "state",
  start_day = "2020-01-01",
  end_day = lubridate::today(),
  input_dir = NULL
)

quarto::quarto_render(
  input = qmd_path,
  output_format = "html",
  output_file = get_output_name(params_nhsn, "_api_state"),
  execute_params = params_nhsn
)
