# NC County Youth Justice

A small SQL Server project that answers one question: **how does my North Carolina county compare with the state on juvenile justice?**

Uses six years (2020–2025) of county data published by the NC Department of Public Safety. The data goes into a SQL Server database, two views calculate rates, and a simple web page shows any county next to the state average.

![Screenshot of the page](docs/screenshot.png)

## What's inside

```
data/county_stats.csv         the data: 100 counties x 6 years (one row per county per year)
data/original_workbooks/      the six Excel files the CSV was made from
sql/01_create_tables.sql      creates database and two tables
sql/02_insert_data.sql        inserts 600 rows
sql/03_create_views.sql       adds rates per 1,000 young people, plus statewide totals
sql/04_export_json.sql        turns the views into JSON for the web page
export_data.ps1               runs 04 and saves docs/data.js
docs/index.html               the web page
```

**Tables:** `counties` (name, area, judicial district) and `county_stats` (one row per county per year: population, complaints, detention, commitments, program numbers).
**Views:** `county_stats_with_rates` (adds three rates) and `state_totals` (statewide sums and rates per year).

## To Run

**Required:** SQL Server and SSMS.

1. Open SSMS and connect to local database.
2. open each file in `sql/` (**01**, **02**, **03**) and run in order.
4. To see the web page, open `docs/index.html` in a browser.

**Refresh the web page after changing the data or views**:

```powershell
.\export_data.ps1
```

## How the CSV was made

Each DPS databook is an Excel file with a *County Data* sheet, and the columns change a bit from year to year. I kept only the columns that appear in all six years and combined them into one file with consistent column names. Data was renamed and compiled with the help of Claude.

## Notes on the numbers

- **Rates are calculated in SQL** as count / population aged 10–17 * 1,000, using the same age group for every year so years can be compared.
- **The state rate** is total complaints / total population, not an average of county rates.
- **Small counties swing a lot.** A few cases can double a rate.

## Source

North Carolina Department of Public Safety, Juvenile Justice Section, *County Databook*, 2020–2025.
