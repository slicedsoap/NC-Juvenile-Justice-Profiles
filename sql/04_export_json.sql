-- =============================================================
-- 04_export_json.sql
-- Returns both views as one JSON document for the web page.
-- export_data.ps1 runs this and saves the result to docs\data.js.
-- =============================================================

USE NCYouthJustice;
GO

SET NOCOUNT ON;

-- FOR JSON PATH turns rows into a JSON array.
SELECT (
    SELECT
        (SELECT * FROM county_stats_with_rates ORDER BY county_name, year FOR JSON PATH) AS counties,
        (SELECT * FROM state_totals ORDER BY year FOR JSON PATH)                     AS state
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
) AS page_data;
