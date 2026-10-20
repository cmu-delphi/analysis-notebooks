
# Revision Analysis (`revision_analysis.qmd`)

`revision_analysis.qmd` focuses on a single versioned time series and attempts to determine how long, on average, a series continues to receive revisions after its first publication. 

## Running the analysis

Because this notebook is a generalized template, **it has no default indicator**. You must explicitly provide the required signal and time window parameters when rendering it.

```bash
quarto render revision_analysis.qmd \
  -P source:nhsn \
  -P signal:confirmed_admissions_covid_ew \
  -P signal_name:"NHSN: Confirmed COVID Admissions" \
  -P geo_type:state \
  -P start_day:2020-01-01 \
  -P end_day:2025-12-31
```

```r
quarto::quarto_render(
  "revision_analysis.qmd",
  execute_params = list(
    source      = "nhsn",
    signal      = "confirmed_admissions_covid_ew",
    signal_name = "NHSN: Confirmed COVID Admissions",
    geo_type    = "state",
    start_day   = "2020-01-01",
    end_day     = "2025-12-31"
  )
)
```

## Parameters

| Parameter               | Description                                                       | Default                                              |
| ----------------------- | ----------------------------------------------------------------- | ---------------------------------------------------- |
| `source`                | Epidata V5 source (see `epidata_meta()`)                          | *None (Required)*                                    |
| `signal`                | Signal name                                                       | *None (Required)*                                    |
| `signal_name`           | Human-readable label                                              | *None (Required)*                                    |
| `input_dir`             | Path to local data (CSV, Parquet, or Directory). `NULL` = use the V5 API | `NULL`                                               |
| `geo_type`              | Geographic level (`state`, `county`, `hhs`, …)                    | *None (Required)*                                    |
| `start_day`             | Start of the time_value range (YYYY-MM-DD)                        | First available date                                 |
| `end_day`               | End of the time_value range (YYYY-MM-DD)                          | Latest available date                                |
| `max_locations_plot`    | Max locations in faceted plots                                    | `6`                                                  |
| `max_locations_table`   | Rows per page in summary tables                                   | `15`                                                 |
| `n_worst`               | Number of worst-behaving locations to highlight in fan plots      | `18`                                                 |
| `convergence_threshold` | Relative tolerance for "converged" (fraction)                     | `0.05`                                               |

## Running on a different signal via the API

You can use the provided example scripts in this directory rather than long `quarto` strings in terminal. 

```bash
Rscript revision_analysis_examples.R
```

## Running on local data

Provide a path to a single CSV, a Parquet file, or a directory of Parquet files (Arrow Dataset) and point `input_dir` at it.

### Required CSV schema

| Column       | Type      | Description                                                                        |
| ------------ | --------- | ---------------------------------------------------------------------------------- |
| `geo_value`  | character | Geographic identifier (`pa`, `06001`, …)                                           |
| `time_value` | date      | Date of the observation (`YYYY-MM-DD`)                                             |
| `version`    | date      | Issue / publication date of this version (`YYYY-MM-DD`). Also accepted as `issue`. |
| `value`      | numeric   | The signal value                                                                   |

> [!IMPORTANT]
> The CSV must contain a `version` or `issue` column. Without it the
> notebook cannot build the `epi_archive` and will error.

```r
quarto::quarto_render(
  "revision_analysis.qmd",
  execute_params = list(
    input_dir   = "revision_analysis/data/revisions/",
    signal_name = "My Custom Signal",
    ...
  )
)
```

```bash
quarto render revision_analysis.qmd \
  -P input_dir:revision_analysis/data/revisions/ \
  -P signal_name:"My Custom Signal" \
  ...
```