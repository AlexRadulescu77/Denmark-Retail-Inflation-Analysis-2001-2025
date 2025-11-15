-- ============================================
-- DAY 4: SQL ANALYSIS QUERIES
-- Database: retail_analysis
-- Table: merged_analysis
-- ============================================

USE retail_analysis;

-- ============================================
-- QUERY 1: Basic Data Overview
-- ============================================
-- See the first 10 rows
SELECT * FROM merged_analysis 
ORDER BY date 
LIMIT 10;

-- See the most recent 10 rows
SELECT * FROM merged_analysis 
ORDER BY date DESC 
LIMIT 10;

-- Count total records
SELECT COUNT(*) AS total_records FROM merged_analysis;

-- ============================================
-- QUERY 2: Summary Statistics
-- ============================================
-- Average values for all metrics
SELECT 
    ROUND(AVG(cpi_total), 2) AS avg_cpi,
    ROUND(AVG(retail_index_total), 2) AS avg_retail,
    ROUND(AVG(consumer_confidence), 2) AS avg_confidence,
    ROUND(AVG(retail_index_adjusted), 2) AS avg_retail_adjusted
FROM merged_analysis;

-- Min and Max values
SELECT 
    MIN(cpi_total) AS min_cpi,
    MAX(cpi_total) AS max_cpi,
    MIN(retail_index_total) AS min_retail,
    MAX(retail_index_total) AS max_retail,
    MIN(consumer_confidence) AS min_confidence,
    MAX(consumer_confidence) AS max_confidence
FROM merged_analysis;

-- ============================================
-- QUERY 3: Year-over-Year Growth Analysis
-- ============================================
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

-- ============================================
-- QUERY 4: Find High Inflation Periods
-- ============================================
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

-- ============================================
-- QUERY 5: Retail Performance During Economic Stress
-- ============================================
-- Find periods where consumer confidence was negative 
-- and see how retail performed
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

-- ============================================
-- QUERY 6: Best and Worst Retail Months
-- ============================================
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

-- ============================================
-- QUERY 7: Inflation vs Retail Relationship
-- ============================================
-- Compare periods of high vs low inflation
-- High inflation (>3% annual)
SELECT 
    'High Inflation (>3%)' AS period_type,
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

-- ============================================
-- QUERY 8: Quarterly Analysis
-- ============================================
-- Average metrics by quarter
SELECT 
    YEAR(date) AS year,
    QUARTER(date) AS quarter,
    CONCAT(YEAR(date), '-Q', QUARTER(date)) AS period,
    ROUND(AVG(cpi_total), 2) AS avg_cpi,
    ROUND(AVG(retail_index_total), 2) AS avg_retail,
    ROUND(AVG(consumer_confidence), 2) AS avg_confidence,
    ROUND(AVG(retail_index_adjusted), 2) AS avg_real_retail
FROM merged_analysis
GROUP BY YEAR(date), QUARTER(date)
ORDER BY year DESC, quarter DESC
LIMIT 20;

-- ============================================
-- QUERY 9: Consumer Confidence Impact
-- ============================================
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

-- ============================================
-- QUERY 10: Recent Trends (Last 24 Months)
-- ============================================
SELECT 
    date,
    cpi_total,
    ROUND(cpi_yoy_change_pct, 2) AS inflation_rate,
    retail_index_total,
    ROUND(retail_yoy_change_pct, 2) AS retail_growth,
    consumer_confidence
FROM merged_analysis
WHERE date >= DATE_SUB((SELECT MAX(date) FROM merged_analysis), INTERVAL 24 MONTH)
ORDER BY date DESC;

-- ============================================
-- QUERY 11: Correlation Approximation
-- ============================================
-- Calculate how CPI and Retail move together (simplified correlation)
-- Positive values = they move together, negative = opposite directions
SELECT 
    YEAR(date) AS year,
    COUNT(*) AS months,
    SUM(CASE 
        WHEN cpi_monthly_change_pct > 0 AND retail_monthly_change_pct > 0 THEN 1
        WHEN cpi_monthly_change_pct < 0 AND retail_monthly_change_pct < 0 THEN 1
        ELSE 0 
    END) AS months_moving_together,
    ROUND(
        (SUM(CASE 
            WHEN cpi_monthly_change_pct > 0 AND retail_monthly_change_pct > 0 THEN 1
            WHEN cpi_monthly_change_pct < 0 AND retail_monthly_change_pct < 0 THEN 1
            ELSE 0 
        END) * 100.0) / COUNT(*), 
        2
    ) AS pct_moving_together
FROM merged_analysis
WHERE cpi_monthly_change_pct IS NOT NULL 
  AND retail_monthly_change_pct IS NOT NULL
GROUP BY YEAR(date)
ORDER BY year DESC;

-- ============================================
-- QUERY 12: Economic Cycles - Identify Peaks and Troughs
-- ============================================
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

-- Find major troughs (low points) in retail
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

-- ============================================
-- QUERY 13: Real vs Nominal Retail Growth
-- ============================================
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

-- ============================================
-- QUERY 14: Seasonal Patterns
-- ============================================
-- Average retail performance by month (across all years)
SELECT 
    MONTH(date) AS month,
    MONTHNAME(date) AS month_name,
    ROUND(AVG(retail_index_total), 2) AS avg_retail,
    ROUND(AVG(consumer_confidence), 2) AS avg_confidence,
    COUNT(*) AS years_data
FROM merged_analysis
GROUP BY MONTH(date), MONTHNAME(date)
ORDER BY MONTH(date);

-- ============================================
-- QUERY 15: Create Summary View for Power BI
-- ============================================
-- This creates a clean summary for visualization
CREATE OR REPLACE VIEW summary_for_powerbi AS
SELECT 
    date,
    YEAR(date) AS year,
    MONTH(date) AS month,
    QUARTER(date) AS quarter,
    cpi_total,
    cpi_yoy_change_pct AS inflation_rate,
    retail_index_total,
    retail_yoy_change_pct AS retail_growth,
    retail_index_adjusted AS real_retail_index,
    consumer_confidence,
    CASE 
        WHEN consumer_confidence > 10 THEN 'High'
        WHEN consumer_confidence > 0 THEN 'Moderate'
        WHEN consumer_confidence > -10 THEN 'Low'
        ELSE 'Very Low'
    END AS confidence_level
FROM merged_analysis
ORDER BY date;

-- View the created view
SELECT * FROM summary_for_powerbi LIMIT 10;