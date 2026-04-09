# Time series processing EDA and correlation analysis

This directory contains scripts and notebooks for evaluating candidate epidemic indicators against guiding indicators using `indicator_evaluation.qmd`, which performs:

- Exploratory Data Analysis (EDA): Coverage, distribution, noise assessment, and revision behaviour.
- Correlation Analysis: Geographic and temporal rank correlations, including optimal lag.

## Installation

You can install Quarto via:

- Homebrew: `brew install --cask quarto`
- R package: `install.packages("quarto")`
- Download from the [Quarto website](https://quarto.org/docs/get-started/).

## Rebuilding the Evaluation

To manually rebuild the evaluation results, run the following command from the root of the package:

Using the CLI:

```bash
quarto render indicator_evaluation.qmd
```

Or from R:

```r
quarto::quarto_render("indicator_evaluation.qmd")
```

## Parameters

| Parameter             | Description                                        | Default                           |
| --------------------- | -------------------------------------------------- | --------------------------------- |
| `guiding_source`      | Data source for the guiding indicator              | `hhs`                             |
| `guiding_signal`      | Signal name for the guiding indicator              | `confirmed_admissions_covid_1d`   |
| `guiding_name`        | Human-readable name for guiding indicator          | `COVID Hospital Admissions (HHS)` |
| `candidate_source`    | Data source for the candidate indicator            | `google-symptoms`                 |
| `candidate_signal`    | Signal name for the candidate indicator            | `anosmia_raw_search`              |
| `candidate_name`      | Human-readable name for candidate indicator        | `Google Symptoms: Anosmia`        |
| `geo_type`            | Geographic level (`state`, `county`, `hhs`, `hrr`) | `state`                           |
| `start_day`           | Start date for analysis (YYYY-MM-DD)               | `2020-09-01`                      |
| `end_day`             | End date for analysis (YYYY-MM-DD)                 | `2023-03-01`                      |
| `guiding_csv`         | Path to local CSV for guiding indicator            | `NULL`                            |
| `candidate_csv`       | Path to local CSV for candidate indicator          | `NULL`                            |
| `max_locations_plot`  | Max locations to show in faceted plots             | `6`                               |
| `max_locations_table` | Max rows to show in location-specific tables       | `15`                              |

## Parameterized Execution

You can evaluate different candidate indicators without re-fetching guiding data by using Quarto parameter overrides.

### Using R

```r
quarto::quarto_render(
  "indicator_evaluation.qmd",
  execute_params = list(
    candidate_source = "google-symptoms",
    candidate_signal = "s02_raw_search",
    candidate_name   = "Google Symptoms: Cough"
  )
)
```

### Using the Command Line

```bash
quarto render indicator_evaluation.qmd \
  -P candidate_source:google-symptoms \
  -P candidate_signal:s02_raw_search \
  -P candidate_name:"Google Symptoms: Cough"
```

## Using Local Data (CSV)

To evaluate indicators using local CSV files instead of the API, set the `guiding_csv` and/or `candidate_csv` parameters to the absolute paths of your files.

### Required CSV Structure

CSV files must include the following columns:

| Column       | Description                                         | Example             |
| ------------ | --------------------------------------------------- | ------------------- |
| `geo_value`  | Geographic identifier                               | `pa`, `ny`, `06001` |
| `time_value` | Date of the observation                             | `2023-01-01`        |
| `value`      | The indicator value (numeric)                       | `12.4`              |
| `version`    | (Optional) Issue/version date for revision analysis | `2023-01-05`        |

> [!NOTE]
> If a `version` (or `issue`) column is provided in `candidate_csv`, the notebook will automatically build an `epi_archive` and enable **Revision Behavior** analysis.

### Running with Local Data

```r
quarto::quarto_render(
  "indicator_evaluation.qmd",
  execute_params = list(
    guiding_csv = "data/guiding.csv",
    candidate_csv = "data/candidate.csv"
  )
)
```
