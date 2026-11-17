-- =============================================================
-- 05_practice_queries.sql
-- Example questions. Highlight one query and press F5 to run it.
-- =============================================================

USE NCYouthJustice;
GO

-- 1. Look at the data: Wake County, every year
SELECT *
FROM county_stats
WHERE county_name = 'Wake'
ORDER BY year;

-- 2. The 10 counties with the most delinquent complaints in 2025 (ORDER BY + TOP)
SELECT TOP (10) county_name, complaints_delinquent_total
FROM county_stats
WHERE year = 2025
ORDER BY complaints_delinquent_total DESC;

-- 3. Same question, but as a rate, so small counties can be compared fairly (using the view)
SELECT TOP (10) county_name, area, population_10_17, complaints_delinquent_total, complaint_rate
FROM county_stats_with_rates
WHERE year = 2025
ORDER BY complaint_rate DESC;

-- 4. Statewide trend (a view with GROUP BY inside)
SELECT year, complaints_delinquent_total, detention_admissions, ydc_commitments, complaint_rate
FROM state_totals
ORDER BY year;

-- 5. Totals by DPS area in 2025 (JOIN + GROUP BY)
SELECT c.area,
       COUNT(*)                           AS counties,
       SUM(s.complaints_delinquent_total) AS complaints,
       SUM(s.ydc_commitments)             AS ydc_commitments
FROM county_stats AS s
JOIN counties AS c ON c.county_name = s.county_name
WHERE s.year = 2025
GROUP BY c.area
ORDER BY complaints DESC;

-- 6. Counties with no YDC commitments in 2025 (WHERE on a number)
SELECT county_name, area, population_10_17
FROM county_stats_with_rates
WHERE year = 2025 AND ydc_commitments = 0
ORDER BY population_10_17 DESC;

-- 7. Label each county as above or below the state rate in 2025 (CASE + a subquery)
SELECT county_name,
       complaint_rate,
       CASE
           WHEN complaint_rate > (SELECT complaint_rate FROM state_totals WHERE year = 2025) THEN 'Above state'
           ELSE 'At or below state'
       END AS compared_with_state
FROM county_stats_with_rates
WHERE year = 2025
ORDER BY complaint_rate DESC;

-- 8. What kinds of complaints? Share of each type statewide in 2025
SELECT
    SUM(complaints_violent) * 100.0 / SUM(complaints_delinquent_total) AS pct_violent,
    SUM(complaints_serious) * 100.0 / SUM(complaints_delinquent_total) AS pct_serious,
    SUM(complaints_minor)   * 100.0 / SUM(complaints_delinquent_total) AS pct_minor
FROM county_stats
WHERE year = 2025;


-- 9. Top 5 counties by YDC commitments, all years combined
SELECT TOP 5 county_name, SUM(ydc_commitments) AS total_commitments
FROM county_stats
GROUP BY county_name
ORDER BY total_commitments DESC;