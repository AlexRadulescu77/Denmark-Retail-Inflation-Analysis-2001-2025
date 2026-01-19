USE retail_analysis;
 1: Basic Data Overview

-- Count total records
SELECT COUNT(*) AS total_records FROM merged_analysis;
-- Summary Statistics

-- 1. Average values for all metrics
SELECT 
    ROUND(AVG(cpi_total), 2) AS avg_cpi,
    ROUND(AVG(retail_index_total), 2) AS avg_retail,
    ROUND(AVG(consumer_confidence), 2) AS avg_confidence,
    ROUND(AVG(retail_index_adjusted), 2) AS avg_retail_adjusted
FROM merged_analysis;

-- 2. Min and Max values
SELECT 
    MIN(cpi_total) AS min_cpi,
    MAX(cpi_total) AS max_cpi,
    MIN(retail_index_total) AS min_retail,
    MAX(retail_index_total) AS max_retail,
    MIN(consumer_confidence) AS min_confidence,
    MAX(consumer_confidence) AS max_confidence
FROM merged_analysis;

-- 3. Year-over-Year Growth Analysis
-- Average annual inflation rate (CPI YoY change) by year
SELECT 
    YEAR(date) AS year,
    ROUND(AVG(cpi_yoy_change_pct), 2) AS avg_annual_inflation,
    ROUND(AVG(retail_yoy_change_pct), 2) AS avg_retail_growth,
    ROUND(AVG(consumer_confidence), 2) AS avg_confidence
FROM merged_analysis
WHERE cpi_yoy_change_pct IS NOT NULL
GROUP BY YEAR(date)
ORDER BY year;


-- 4. High Inflation Periods
-- Months with inflation above 5%
SELECT 
    date,
    cpi_total,
    cpi_yoy_change_pct AS annual_inflation,
    retail_yoy_change_pct AS retail_growth,
    consumer_confidence
FROM merged_analysis
WHERE cpi_yoy_change_pct > 5.0
ORDER BY cpi_yoy_change_pct DESC;


-- 5. Retail Performance During Economic Stress
-- Find periods where consumer confidence was negative  and see how retail performed
SELECT 
    date,
    consumer_confidence,
    retail_index_total,
    retail_monthly_change_pct,
    cpi_yoy_change_pct AS inflation
FROM merged_analysis
WHERE consumer_confidence < 0
ORDER BY consumer_confidence ASC
LIMIT 20;

-- QUERY 6: Best and Worst Retail Months
-- Top 10 months for retail growth
SELECT 
    date,
    retail_index_total,
    retail_monthly_change_pct,
    consumer_confidence,
    cpi_monthly_change_pct AS inflation
FROM merged_analysis
WHERE retail_monthly_change_pct IS NOT NULL
ORDER BY retail_monthly_change_pct DESC
LIMIT 10;

-- Bottom 10 months (worst retail performance)
SELECT 
    date,
    retail_index_total,
    retail_monthly_change_pct,
    consumer_confidence,
    cpi_monthly_change_pct AS inflation
FROM merged_analysis
WHERE retail_monthly_change_pct IS NOT NULL
ORDER BY retail_monthly_change_pct ASC
LIMIT 10;

-- 7. Inflation vs Retail Relationship
-- Compare periods of high (>3% annual) vs low inflation
SELECT 
    'High Inflation' AS period_type,
    COUNT(*) AS months_count,
    ROUND(AVG(cpi_yoy_change_pct), 2) AS avg_inflation,
    ROUND(AVG(retail_yoy_change_pct), 2) AS avg_retail_growth,
    ROUND(AVG(consumer_confidence), 2) AS avg_confidence
FROM merged_analysis
WHERE cpi_yoy_change_pct > 3.0

UNION ALL

-- Low inflation (<1% annual)
SELECT 
    'Low Inflation (<1%)' AS period_type,
    COUNT(*) AS months_count,
    ROUND(AVG(cpi_yoy_change_pct), 2) AS avg_inflation,
    ROUND(AVG(retail_yoy_change_pct), 2) AS avg_retail_growth,
    ROUND(AVG(consumer_confidence), 2) AS avg_confidence
FROM merged_analysis
WHERE cpi_yoy_change_pct < 1.0 AND cpi_yoy_change_pct IS NOT NULL;


-- 8. Consumer Confidence Impact
-- Compare retail performance when confidence is positive vs negative
SELECT 
    CASE 
        WHEN consumer_confidence > 0 THEN 'Positive Confidence'
        WHEN consumer_confidence < 0 THEN 'Negative Confidence'
        ELSE 'Neutral'
    END AS confidence_category,
    COUNT(*) AS months,
    ROUND(AVG(consumer_confidence), 2) AS avg_confidence,
    ROUND(AVG(retail_monthly_change_pct), 2) AS avg_retail_monthly_growth,
    ROUND(AVG(cpi_monthly_change_pct), 2) AS avg_monthly_inflation
FROM merged_analysis
WHERE consumer_confidence IS NOT NULL
GROUP BY confidence_category;


-- 9. Economic Cycles - Identify Peaks and Troughs

-- Find major peaks (high points) in retail
SELECT 
    date,
    retail_index_total,
    consumer_confidence,
    cpi_total,
    'Peak' AS cycle_point
FROM merged_analysis
WHERE retail_index_total > (
    SELECT AVG(retail_index_total) + STDDEV(retail_index_total) 
    FROM merged_analysis
)
ORDER BY retail_index_total DESC
LIMIT 10;

-- Find major low points in retail
SELECT 
    date,
    retail_index_total,
    consumer_confidence,
    cpi_total,
    'Trough' AS cycle_point
FROM merged_analysis
WHERE retail_index_total < (
    SELECT AVG(retail_index_total) - STDDEV(retail_index_total) 
    FROM merged_analysis
)
ORDER BY retail_index_total ASC
LIMIT 10;

-- 10. Real vs Nominal Retail Growth
-- Compare actual retail index vs inflation-adjusted
SELECT 
    YEAR(date) AS year,
    ROUND(AVG(retail_index_total), 2) AS avg_nominal_retail,
    ROUND(AVG(retail_index_adjusted), 2) AS avg_real_retail,
    ROUND(AVG(retail_index_adjusted) - AVG(retail_index_total), 2) AS inflation_impact,
    ROUND(AVG(cpi_yoy_change_pct), 2) AS avg_inflation
FROM merged_analysis
GROUP BY YEAR(date)
ORDER BY year DESC;
