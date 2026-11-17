# Enhancement tasks

Small tasks, roughly in order. Each one teaches one SQL idea. Write your query in SSMS first; once it works, save it in the right `sql/` file.

| # | Task | SQL idea | Done when |
|---|---|---|---|
| 1 | Add a screenshot of the page as `docs/screenshot.png` so the README image works | none, but it makes the repo look finished | The image shows on GitHub |
| 2 | Write a query: the 5 counties with the **most YDC commitments** across all six years combined | `GROUP BY`, `SUM`, `ORDER BY`, `TOP` | Guilford is first, with 115 |
| 3 | Add a `violent_share` column to `county_stats_with_rates`: violent complaints as a % of delinquent complaints | calculated columns, `NULLIF`, `CAST` | `SELECT * FROM county_stats_with_rates` shows the new column |
| 4 | Make the database reject bad data: add a `CHECK` so no count can be negative, then try inserting a row with `-5` | constraints | Your bad `INSERT` fails with a CHECK error |
| 5 | Create a view `area_totals` like `state_totals` but grouped by **area and year** | `JOIN` + `GROUP BY` two columns | It returns 24 rows (4 areas × 6 years) |
| 6 | Show the area on the page: add `area_totals` to `04_export_json.sql`, then add a third line to the chart | using a view from the page | The chart has county, area and state lines |
| 7 | Add a "change from last year" column to the page's table | `LAG()` (your first window function) | 2020 shows blank and the other years show + or − |
| 8 | Write a stored procedure `get_county @county_name` that returns that county's six years | stored procedures, parameters | `EXEC get_county 'Durham'` returns 6 rows |
| 9 | Rank counties by complaint rate in 2025 and show "Rank X of 100" on the page | `RANK()` | Each county's card shows its rank |

**Bigger, optional:** add a map of NC's counties colored by complaint rate, using a public NC county GeoJSON file and Leaflet.

Tip: commit after each task (`git commit -m "Task 3: violent share column"`) so your GitHub history shows your progress.
