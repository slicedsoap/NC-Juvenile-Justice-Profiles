SELECT * FROM counties;

SELECT TOP 5 county_name, SUM(ydc_commitments) AS total_commitments
FROM county_stats
GROUP BY county_name
ORDER BY total_commitments DESC;

SELECT *
FROM county_stats;


SELECT (complaints_violent / complaints_delinquent_total) * 100 AS 'violent %'
From county_stats;

SELECT county_name, CAST(SUM(complaints_violent) * 100.0 / NULLIF(SUM(complaints_delinquent_total), 0)  AS decimal(8,2) ) AS v
From county_stats
GROUP BY county_name;

SELECT county_name, year, 
CAST(complaints_violent * 100.0 / NULLIF(complaints_delinquent_total, 0)  AS decimal(5,2) ) AS 'violent_share'
From county_stats
WHERE county_name = 'Wake';

SELECT * FROM county_stats_with_rates WHERE county_name = 'Wake';