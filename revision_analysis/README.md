
# Revision Analysis (`revision_analysis.qmd`)

`revision_analysis.qmd` focuses on a single versioned time series and attempts to determine how long, on average, a series continues to receive revisions after its first publication. 

## Running the default analysis

The default indicator is `smoothed_covid19_from_claims` from the
`hospital-admissions` source, fetched directly from the Delphi API.

```bash
quarto render revision_analysis.qmd
```

```r
quarto::quarto_render("revision_analysis.qmd")
```

## Parameters

| Parameter               | Description                                                       | Default                                              |
| ----------------------- | ----------------------------------------------------------------- | ---------------------------------------------------- |
| `source`                | COVIDcast data source                                             | `hospital-admissions`                                |
| `signal`                | Signal name                                                       | `smoothed_covid19_from_claims`                       |
| `signal_name`           | Human-readable label                                              | `Hospital Admissions: Smoothed COVID-19 from Claims` |
| `input`                 | Path to local data (CSV, Parquet, or Directory). `NULL` = use API | `NULL`                                               |
| `geo_type`              | Geographic level (`state`, `county`, `hhs`, …)                    | `state`                                              |
| `time_type`             | Time resolution (`day`, `week`)                                   | `day`                                                |
| `start_day`             | Start of the time_value range (YYYY-MM-DD)                        | `2020-09-01`                                         |
| `end_day`               | End of the time_value range (YYYY-MM-DD)                          | `2023-03-01`                                         |
| `max_locations_plot`    | Max locations in faceted plots                                    | `6`                                                  |
| `max_locations_table`   | Rows per page in summary tables                                   | `15`                                                 |
| `quick_revision`        | Days threshold used in `revision_analysis()` print summary        | `7`                                                  |
| `n_worst`               | Number of worst-behaving locations to highlight in fan plots      | `18`                                                 |
| `convergence_threshold` | Relative tolerance for "converged" (fraction)                     | `0.05`                                               |

## Running on a different signal via the API

```bash
quarto render revision_analysis.qmd \
  -P source:doctor-visits \
  -P signal:smoothed_adj_cli \
  -P signal_name:"Doctor Visits: Smoothed Adj CLI" \
  -P geo_type:state
```

```r
quarto::quarto_render(
  "revision_analysis.qmd",
  execute_params = list(
    source      = "doctor-visits",
    signal      = "smoothed_adj_cli",
    signal_name = "Doctor Visits: Smoothed Adj CLI",
    geo_type    = "state"
  )
)
```

## Running on local data

Provide a path to a single CSV, a Parquet file, or a directory of Parquet files (Arrow Dataset) and point `input` at it.

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
    input       = "revision_analysis/data/revisions/",
    signal_name = "My Custom Signal"
  )
)
```

```bash
quarto render revision_analysis.qmd \
  -P input:revision_analysis/data/revisions/ \
  -P signal_name:"My Custom Signal"
```