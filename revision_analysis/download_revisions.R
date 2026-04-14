#' Download Delphi API data by month for 2020-2023
#' Stores as monthly Parquet files in data/revisions/

if (!require("pacman")) install.packages("pacman")
pacman::p_load(epidatr, tidyverse, arrow, fs, lubridate, glue)

# Configuration (for claims data)
PARS <- list(
    source    = "hospital-admissions",
    signal    = "smoothed_covid19_from_claims",
    geo_type  = "state",
    time_type = "day",
    start_day = "2020-01-01",
    end_day   = "2023-12-31"
)

# Output directory
output_dir <- here::here("revision_analysis", "data", "revisions")
if (!dir_exists(output_dir)) dir_create(output_dir)

# Create monthly intervals
month_starts <- seq(as.Date(PARS$start_day), as.Date(PARS$end_day), by = "month")
month_ends <- ceiling_date(month_starts, "month") - days(1)

# Ensure last end_day doesn't exceed PARS$end_day
last_idx <- length(month_ends)
if (month_ends[last_idx] > as.Date(PARS$end_day)) {
    month_ends[last_idx] <- as.Date(PARS$end_day)
}

cli::cli_h1("Starting Batch Download: {PARS$start_day} to {PARS$end_day}")
cli::cli_inform("Saving to: {.path {output_dir}}")

for (i in seq_along(month_starts)) {
    s <- month_starts[i]
    e <- min(month_ends[i], as.Date(PARS$end_day))

    file_name <- glue("revisions_{format(s, '%Y_%m')}.parquet")
    file_path <- path(output_dir, file_name)

    if (file_exists(file_path)) {
        cli::cli_inform(c("-" = "Skipping {s} to {e} (already exists)"))
        next
    }

    cli::cli_inform(c(">" = "Downloading {s} to {e}..."))

    tryCatch(
        {
            df_raw <- pub_covidcast(
                source = PARS$source,
                signal = PARS$signal,
                geo_type = PARS$geo_type,
                time_type = PARS$time_type,
                time_values = epirange(s, e),
                issues = "*"
            )

            if (nrow(df_raw) > 0) {
                write_parquet(df_raw, file_path)
                cli::cli_inform(c("v" = "Saved {.file {file_name}} ({nrow(df_raw)} rows)"))
            } else {
                cli::cli_warn("No data found for {s} to {e}")
            }
        },
        error = function(err) {
            cli::cli_alert_danger("Failed to download {s} to {e}: {err$message}")
        }
    )
}

cli::cli_h1("Batch Download Complete")
