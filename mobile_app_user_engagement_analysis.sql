-- ============================================================
-- Mobile App User Engagement & Churn Analysis

-- ============================================================

CREATE DATABASE IF NOT EXISTS mobile_app_analytics;
USE mobile_app_analytics;

-- ------------------------------------------------------------
-- 1. Raw/source table
-- ------------------------------------------------------------
DROP TABLE IF EXISTS mobile_app_user_engagement;

CREATE TABLE mobile_app_user_engagement (
    user_id VARCHAR(50),
    gender VARCHAR(20),
    age INT,
    country VARCHAR(50),
    device_type VARCHAR(30),
    app_version DECIMAL(3,1),
    sessions_per_day INT,
    avg_session_duration_min DECIMAL(10,2),
    screens_viewed INT,
    push_notifications_clicked INT,
    in_app_purchases INT,
    subscription_status VARCHAR(20),
    churn_risk_score DECIMAL(5,4),
    last_login_date DATE,
    user_rating DECIMAL(3,1)
);

-- ------------------------------------------------------------


LOAD DATA LOCAL INFILE 'Mobile App User Engagement(1).csv'
INTO TABLE mobile_app_user_engagement
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(user_id, gender, age, country, device_type, app_version,
 sessions_per_day, avg_session_duration_min, screens_viewed,
 push_notifications_clicked, in_app_purchases, subscription_status,
 churn_risk_score, @last_login_date, user_rating)
SET last_login_date = STR_TO_DATE(@last_login_date, '%c/%e/%Y');

-- ------------------------------------------------------------
-- 3. Data-quality checks
-- ------------------------------------------------------------

-- Record count
SELECT COUNT(*) AS total_records
FROM mobile_app_user_engagement;

-- Distinct User IDs
SELECT COUNT(DISTINCT user_id) AS distinct_user_ids
FROM mobile_app_user_engagement;

-- Missing values by source field
SELECT
    SUM(user_id IS NULL OR user_id = '') AS missing_user_id,
    SUM(gender IS NULL OR gender = '') AS missing_gender,
    SUM(age IS NULL) AS missing_age,
    SUM(country IS NULL OR country = '') AS missing_country,
    SUM(device_type IS NULL OR device_type = '') AS missing_device_type,
    SUM(app_version IS NULL) AS missing_app_version,
    SUM(sessions_per_day IS NULL) AS missing_sessions_per_day,
    SUM(avg_session_duration_min IS NULL) AS missing_session_duration,
    SUM(screens_viewed IS NULL) AS missing_screens_viewed,
    SUM(push_notifications_clicked IS NULL) AS missing_push_clicks,
    SUM(in_app_purchases IS NULL) AS missing_purchases,
    SUM(subscription_status IS NULL OR subscription_status = '') AS missing_subscription,
    SUM(churn_risk_score IS NULL) AS missing_churn_risk,
    SUM(last_login_date IS NULL) AS missing_last_login,
    SUM(user_rating IS NULL) AS missing_rating
FROM mobile_app_user_engagement;

-- ------------------------------------------------------------
-- 4. Analytics view
-- ------------------------------------------------------------
-- Engagement Score formula copied from the supplied notebook:
-- (Sessions Per Day * Avg Session Duration Min)
-- + (Screens Viewed * 0.5)
-- + (In App Purchases * 2)

DROP VIEW IF EXISTS vw_user_engagement_analysis;

CREATE VIEW vw_user_engagement_analysis AS
SELECT
    user_id,
    gender,
    age,
    CASE
        WHEN age <= 17 THEN '<18'
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    country,
    device_type,
    app_version,
    sessions_per_day,
    avg_session_duration_min,
    screens_viewed,
    push_notifications_clicked,
    in_app_purchases,
    subscription_status,
    churn_risk_score,
    last_login_date,
    DATE_FORMAT(last_login_date, '%Y-%m') AS login_month,
    user_rating,
    ROUND(
        (sessions_per_day * avg_session_duration_min)
        + (screens_viewed * 0.5)
        + (in_app_purchases * 2),
        2
    ) AS engagement_score
FROM mobile_app_user_engagement;

-- ============================================================
-- BUSINESS ANALYSIS QUERIES
-- ============================================================

-- Q1. Headline KPIs
SELECT
    COUNT(*) AS total_records,
    ROUND(AVG(sessions_per_day), 2) AS avg_sessions_per_day,
    ROUND(AVG(avg_session_duration_min), 2) AS avg_session_duration_min,
    ROUND(AVG(screens_viewed), 2) AS avg_screens_viewed,
    ROUND(AVG(push_notifications_clicked), 2) AS avg_push_notifications_clicked,
    ROUND(AVG(in_app_purchases), 2) AS avg_in_app_purchases,
    ROUND(AVG(engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(churn_risk_score), 3) AS avg_churn_risk_score,
    ROUND(AVG(user_rating), 2) AS avg_user_rating
FROM vw_user_engagement_analysis;

-- Q2. Average session duration by device type
SELECT
    device_type,
    COUNT(*) AS record_count,
    ROUND(AVG(avg_session_duration_min), 2) AS avg_session_duration_min
FROM vw_user_engagement_analysis
GROUP BY device_type
ORDER BY avg_session_duration_min DESC;

-- Q3. User/record count by app version
SELECT
    app_version,
    COUNT(*) AS user_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM vw_user_engagement_analysis
GROUP BY app_version
ORDER BY app_version;

-- Q4. Country-wise average engagement in sessions per day
SELECT
    country,
    COUNT(*) AS record_count,
    ROUND(AVG(sessions_per_day), 2) AS avg_sessions_per_day
FROM vw_user_engagement_analysis
GROUP BY country
ORDER BY avg_sessions_per_day DESC;

-- Q5. Churn-risk distribution by subscription type
SELECT
    subscription_status,
    COUNT(*) AS record_count,
    ROUND(AVG(churn_risk_score), 3) AS mean_churn_risk,
    ROUND(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(
                GROUP_CONCAT(churn_risk_score ORDER BY churn_risk_score),
                ',',
                CEIL(COUNT(*) / 2)
            ),
            ',',
            -1
        ),
        3
    ) AS approximate_median_risk,
    ROUND(STDDEV_SAMP(churn_risk_score), 3) AS stddev_churn_risk,
    ROUND(AVG(engagement_score), 2) AS avg_engagement_score
FROM vw_user_engagement_analysis
GROUP BY subscription_status
ORDER BY mean_churn_risk DESC;

-- Q6. Average sessions per day by age group
SELECT
    age_group,
    COUNT(*) AS record_count,
    ROUND(AVG(sessions_per_day), 2) AS avg_sessions_per_day
FROM vw_user_engagement_analysis
GROUP BY age_group
ORDER BY
    CASE age_group
        WHEN '<18' THEN 1
        WHEN '18-24' THEN 2
        WHEN '25-34' THEN 3
        WHEN '35-44' THEN 4
        WHEN '45-54' THEN 5
        WHEN '55-64' THEN 6
        WHEN '65+' THEN 7
    END;

-- Q7. Subscription distribution
SELECT
    subscription_status,
    COUNT(*) AS user_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM vw_user_engagement_analysis
GROUP BY subscription_status
ORDER BY share_pct DESC;

-- Q8. Push notification interaction distribution
SELECT
    push_notifications_clicked,
    COUNT(*) AS user_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM vw_user_engagement_analysis
GROUP BY push_notifications_clicked
ORDER BY push_notifications_clicked;

-- Q9. Monthly login activity
SELECT
    login_month,
    COUNT(*) AS login_record_count
FROM vw_user_engagement_analysis
GROUP BY login_month
ORDER BY login_month;

-- Q10. Latest login period check
SELECT
    login_month,
    COUNT(*) AS login_record_count
FROM vw_user_engagement_analysis
GROUP BY login_month
ORDER BY login_month DESC
LIMIT 3;

-- Q11. Core metric summary
SELECT 'Sessions Per Day' AS metric,
       ROUND(AVG(sessions_per_day), 2) AS mean_value,
       ROUND(MIN(sessions_per_day), 2) AS min_value,
       ROUND(MAX(sessions_per_day), 2) AS max_value
FROM vw_user_engagement_analysis
UNION ALL
SELECT 'Avg Session Duration Min',
       ROUND(AVG(avg_session_duration_min), 2),
       ROUND(MIN(avg_session_duration_min), 2),
       ROUND(MAX(avg_session_duration_min), 2)
FROM vw_user_engagement_analysis
UNION ALL
SELECT 'Screens Viewed',
       ROUND(AVG(screens_viewed), 2),
       ROUND(MIN(screens_viewed), 2),
       ROUND(MAX(screens_viewed), 2)
FROM vw_user_engagement_analysis
UNION ALL
SELECT 'Push Notifications Clicked',
       ROUND(AVG(push_notifications_clicked), 2),
       ROUND(MIN(push_notifications_clicked), 2),
       ROUND(MAX(push_notifications_clicked), 2)
FROM vw_user_engagement_analysis
UNION ALL
SELECT 'In App Purchases',
       ROUND(AVG(in_app_purchases), 2),
       ROUND(MIN(in_app_purchases), 2),
       ROUND(MAX(in_app_purchases), 2)
FROM vw_user_engagement_analysis
UNION ALL
SELECT 'Engagement Score',
       ROUND(AVG(engagement_score), 2),
       ROUND(MIN(engagement_score), 2),
       ROUND(MAX(engagement_score), 2)
FROM vw_user_engagement_analysis
UNION ALL
SELECT 'Churn Risk Score',
       ROUND(AVG(churn_risk_score), 2),
       ROUND(MIN(churn_risk_score), 2),
       ROUND(MAX(churn_risk_score), 2)
FROM vw_user_engagement_analysis
UNION ALL
SELECT 'User Rating',
       ROUND(AVG(user_rating), 2),
       ROUND(MIN(user_rating), 2),
       ROUND(MAX(user_rating), 2)
FROM vw_user_engagement_analysis;

-- Q12. Engagement score distribution / ranking
SELECT
    user_id,
    subscription_status,
    country,
    device_type,
    engagement_score,
    churn_risk_score,
    user_rating
FROM vw_user_engagement_analysis
ORDER BY engagement_score DESC
LIMIT 20;

-- Q13. High-risk + low-engagement behavioral segment
-- This is an analytical segmentation example, not an observed churn label.
-- Thresholds use the dataset medians so the segment is relative to this sample.
WITH thresholds AS (
    SELECT
        (SELECT AVG(churn_risk_score)
         FROM vw_user_engagement_analysis) AS avg_risk,
        (SELECT AVG(engagement_score)
         FROM vw_user_engagement_analysis) AS avg_engagement
)
SELECT
    CASE
        WHEN v.churn_risk_score >= t.avg_risk
             AND v.engagement_score < t.avg_engagement
            THEN 'High Risk + Low Engagement'
        WHEN v.churn_risk_score >= t.avg_risk
             AND v.engagement_score >= t.avg_engagement
            THEN 'High Risk + High Engagement'
        WHEN v.churn_risk_score < t.avg_risk
             AND v.engagement_score < t.avg_engagement
            THEN 'Low Risk + Low Engagement'
        ELSE 'Low Risk + High Engagement'
    END AS behavioral_segment,
    COUNT(*) AS record_count,
    ROUND(AVG(v.churn_risk_score), 3) AS avg_churn_risk,
    ROUND(AVG(v.engagement_score), 2) AS avg_engagement
FROM vw_user_engagement_analysis v
CROSS JOIN thresholds t
GROUP BY behavioral_segment
ORDER BY record_count DESC;

-- Q14. Trial-to-Premium analysis foundation
-- The supplied data has subscription status but no conversion history,
-- so an actual Trial -> Premium conversion rate cannot be calculated.
SELECT
    subscription_status,
    COUNT(*) AS record_count,
    ROUND(AVG(sessions_per_day), 2) AS avg_sessions_per_day,
    ROUND(AVG(avg_session_duration_min), 2) AS avg_session_duration_min,
    ROUND(AVG(screens_viewed), 2) AS avg_screens_viewed,
    ROUND(AVG(push_notifications_clicked), 2) AS avg_push_clicks,
    ROUND(AVG(user_rating), 2) AS avg_rating
FROM vw_user_engagement_analysis
GROUP BY subscription_status
ORDER BY subscription_status;

-- Q15. App-version performance beyond adoption
SELECT
    app_version,
    COUNT(*) AS record_count,
    ROUND(AVG(sessions_per_day), 2) AS avg_sessions_per_day,
    ROUND(AVG(avg_session_duration_min), 2) AS avg_session_duration_min,
    ROUND(AVG(engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(churn_risk_score), 3) AS avg_churn_risk,
    ROUND(AVG(user_rating), 2) AS avg_rating
FROM vw_user_engagement_analysis
GROUP BY app_version
ORDER BY app_version;

-- Q16. Notification engagement vs. user behavior
SELECT
    push_notifications_clicked,
    COUNT(*) AS record_count,
    ROUND(AVG(sessions_per_day), 2) AS avg_sessions_per_day,
    ROUND(AVG(engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(churn_risk_score), 3) AS avg_churn_risk,
    ROUND(AVG(user_rating), 2) AS avg_rating
FROM vw_user_engagement_analysis
GROUP BY push_notifications_clicked
ORDER BY push_notifications_clicked;

-- ============================================================
-- OPTIONAL: Useful Power BI / dashboard extraction queries
-- ============================================================

-- User-level analytical dataset
SELECT *
FROM vw_user_engagement_analysis;

-- Country + subscription summary
SELECT
    country,
    subscription_status,
    COUNT(*) AS record_count,
    ROUND(AVG(engagement_score), 2) AS avg_engagement_score,
    ROUND(AVG(churn_risk_score), 3) AS avg_churn_risk,
    ROUND(AVG(user_rating), 2) AS avg_rating
FROM vw_user_engagement_analysis
GROUP BY country, subscription_status
ORDER BY country, subscription_status;

-- Device + app version summary
SELECT
    device_type,
    app_version,
    COUNT(*) AS record_count,
    ROUND(AVG(sessions_per_day), 2) AS avg_sessions_per_day,
    ROUND(AVG(avg_session_duration_min), 2) AS avg_session_duration_min,
    ROUND(AVG(engagement_score), 2) AS avg_engagement_score
FROM vw_user_engagement_analysis
GROUP BY device_type, app_version
ORDER BY device_type, app_version;

