# Time series processing EDA and correlation analysis

This directory contains scripts and notebooks for evaluating candidate epidemic indicators against guiding indicators using `indicator_evaluation.qmd`, which performs:

- Exploratory Data Analysis (EDA): Coverage, distribution, noise assessment, and revision behaviour.
- Correlation Analysis: Geographic and temporal rank correlations, including optimal lag.

## Installation

You can install Quarto via:

- Homebrew: `brew install --cask quarto`
- R package: `install.packages("quarto")`
- Download from the [Quarto website](https://quarto.org/docs/get-started/).

## Running the analysis

Because this notebook is a generalized template, **it has no default indicator**. You must explicitly provide all required parameters when rendering it.

Using the CLI:

```bash
quarto render indicator_evaluation.qmd \
  -P guiding_source:hhs \
  -P guiding_indicator:confirmed_admissions_covid_1d \
  -P guiding_name:"COVID Hospital Admissions (HHS)" \
  -P candidate_source:google-symptoms \
  -P candidate_indicator:s02_raw_search \
  -P candidate_name:"Google Symptoms: Cough" \
  -P geo_type:state \
  -P time_type:day \
  -P start_day:2020-09-01 \
  -P end_day:2023-03-01
```

Or from R:

```r
quarto::quarto_render(
  "indicator_evaluation.qmd",
  execute_params = list(
    guiding_source = "hhs",
    guiding_indicator = "confirmed_admissions_covid_1d",
    guiding_name = "COVID Hospital Admissions (HHS)",
    candidate_source = "google-symptoms",
    candidate_indicator = "s02_raw_search",
    candidate_name = "Google Symptoms: Cough",
    geo_type = "state",
    time_type = "day",
    start_day = "2020-09-01",
    end_day = "2023-03-01"
  )
)
```

## Parameters

| Parameter             | Description                                        | Default                           |
|-----------------------|----------------------------------------------------|-----------------------------------|
| `guiding_source`      | Data source for the guiding indicator              | *None (Required)* |
| `guiding_indicator`   | Indicator name for the guiding indicator           | *None (Required)* |
| `guiding_name`        | Human-readable name for guiding indicator          | *None (Required)* |
| `candidate_source`    | Data source for the candidate indicator            | *None (Required)* |
| `candidate_indicator` | Indicator name for the candidate indicator         | *None (Required)* |
| `candidate_name`      | Human-readable name for candidate indicator        | *None (Required)* |
| `geo_type`            | Geographic level (`state`, `county`, `hhs`, `hrr`) | *None (Required)* |
| `time_type`           | Time resolution (`day`, `week`)                    | *None (Required)* |
| `start_day`           | Start date for analysis (YYYY-MM-DD)               | *None (Required)* |
| `end_day`             | End date for analysis (YYYY-MM-DD)                 | *None (Required)* |
| `guiding_csv`         | Path to local CSV for guiding indicator            | `NULL`                            |
| `candidate_csv`       | Path to local CSV for candidate indicator          | `NULL`                            |
| `max_locations_plot`  | Max locations to show in faceted plots             | `6`                               |

### Using the Command Line

You can use the provided example scripts in this directory rather than long `quarto` strings in terminal. 

```bash
Rscript indicator_evaluation_examples.R
```

## Using Local Data (CSV)

To evaluate indicators using local CSV files instead of the API, set the `guiding_csv` and/or `candidate_csv` parameters to the absolute paths of your files.

### Required CSV Structure

CSV files must include the following columns:

| Column | Description | Example |
| --- | --- | --- |
| `geo_value` | Geographic identifier | `pa`, `ny`, `06001` |
| `time_value` | Date of the observation | `2023-01-01` |
| `value` | The indicator value (numeric) | `12.4` |
| `version` | (Optional) Issue/version date for revision analysis | `2023-01-05` |

> [!NOTE]
> If a `version` (or `issue`) column is provided in `candidate_csv`, the notebook will automatically build an `epi_archive` and enable **Revision Behavior** analysis.

### Running with Local Data

```r
quarto::quarto_render(
  "indicator_evaluation.qmd",
  execute_params = list(
    guiding_csv = "data/guiding.csv",
    candidate_csv = "data/candidate.csv"
    # ... remember to supply other global required parameters
  )
)
```
