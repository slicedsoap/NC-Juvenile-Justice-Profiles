-- =============================================================
-- 03_create_views.sql
-- Views that add calculated rates, used by the queries and the web page.
-- =============================================================

USE NCYouthJustice;
GO

-- Every county-year row, plus its area and three rates.
-- Rates are "per 1,000 young people aged 10-17", so counties of
-- different sizes can be compared.
--   * 1000.0 (not 1000) makes SQL Server do decimal division
--            instead of integer division (which would round to 0).
--   NULLIF(x, 0) turns a zero population into NULL, which avoids
--            a divide-by-zero error.
CREATE OR ALTER VIEW county_stats_with_rates AS
SELECT
    s.county_name,
    c.area,
    s.year,
    s.population_10_17,
    s.complaints_delinquent_total,
    s.detention_admissions,
    s.ydc_commitments,
    s.jcpc_youth_served,
    CAST(s.complaints_delinquent_total * 1000.0 / NULLIF(s.population_10_17, 0) AS decimal(8,2)) AS complaint_rate,
    CAST(s.detention_admissions        * 1000.0 / NULLIF(s.population_10_17, 0) AS decimal(8,2)) AS detention_rate,
    CAST(s.ydc_commitments             * 1000.0 / NULLIF(s.population_10_17, 0) AS decimal(8,3)) AS ydc_rate
FROM county_stats AS s
JOIN counties AS c ON c.county_name = s.county_name;
GO

-- Statewide totals per year. The state rate is total complaints divided
-- by total population, not the average of the 100 county rates
-- (an average would give a tiny county as much weight as a big one).
CREATE OR ALTER VIEW state_totals AS
SELECT
    year,
    SUM(population_10_17)            AS population_10_17,
    SUM(complaints_delinquent_total) AS complaints_delinquent_total,
    SUM(detention_admissions)        AS detention_admissions,
    SUM(ydc_commitments)             AS ydc_commitments,
    SUM(jcpc_youth_served)           AS jcpc_youth_served,
    CAST(SUM(complaints_delinquent_total) * 1000.0 / SUM(population_10_17) AS decimal(8,2)) AS complaint_rate,
    CAST(SUM(detention_admissions)        * 1000.0 / SUM(population_10_17) AS decimal(8,2)) AS detention_rate,
    CAST(SUM(ydc_commitments)             * 1000.0 / SUM(population_10_17) AS decimal(8,3)) AS ydc_rate
FROM county_stats
GROUP BY year;
GO

PRINT 'Views created.';
