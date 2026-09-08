# Mobile App User Engagement & Churn Analysis

A complete Data Analytics portfolio project focused on understanding mobile-app engagement, subscription mix, churn-risk profiling, product usage, and retention opportunities.

The project combines **Python/Pandas analysis, SQL business analysis, and a professional business report** using the supplied mobile-app engagement dataset.

## Project Overview

The analysis explores:

- User engagement and session behavior
- Subscription distribution across Free, Trial, and Premium
- Churn Risk Score profiling
- Behavioral retention segmentation
- Age and country-level engagement
- Device and app-version performance
- Push-notification interactions
- Monthly login activity
- User satisfaction and ratings
- Correlations between engagement variables and churn risk
- Repeatable SQL business queries for future BI reporting

> **Important:** The dataset contains a Churn Risk Score, but it does not contain an observed churn/cancellation outcome. Therefore, this project performs **churn-risk profiling**, not measured churn-rate analysis.

## Dataset

The supplied CSV contains:

- **20,000 records**
- **15 source fields**
- Login dates from **01 January 2023 to 01 June 2025**
- No missing values across the source fields

The raw file contains **2,000 distinct User IDs across 20,000 records**. Because of this, record-level counts should not automatically be interpreted as unique users.

### Main Fields

| Category | Fields |
|---|---|
| User | User ID, Gender, Age |
| Geography & Platform | Country, Device Type, App Version |
| Engagement | Sessions Per Day, Avg Session Duration Min, Screens Viewed |
| Messaging | Push Notifications Clicked |
| Monetization | In App Purchases, Subscription Status |
| Risk & Satisfaction | Churn Risk Score, User Rating |
| Time | Last Login Date |

## Engagement Score

The project uses the Engagement Score defined in the supplied Python analysis:

```text
Engagement Score =
    (Sessions Per Day × Avg Session Duration Min)
    + (Screens Viewed × 0.5)
    + (In App Purchases × 2)
```

This is a custom composite index designed for relative comparison and segmentation within this dataset. It should not be treated as a standard industry metric.

## Key Findings

### Overall Engagement

| Metric | Result |
|---|---:|
| Records | 20,000 |
| Distinct User IDs | 2,000 |
| Avg Sessions/Day | 7.47 |
| Avg Session Duration | 30.45 min |
| Avg Screens Viewed | 26.99 |
| Avg Push Notification Clicks | 4.46 |
| Avg In-App Purchases | 2.00 |
| Avg Engagement Score | 245.54 |
| Avg Churn Risk Score | 0.497 |
| Avg User Rating | 2.99 / 5 |

### Subscription Mix

- **Premium:** 6,767 records, 33.8%
- **Free:** 6,653 records, 33.3%
- **Trial:** 6,580 records, 32.9%

The subscription base is highly balanced.

### Churn Risk

Average Churn Risk Score is almost identical across subscription groups:

- Free: **0.499**
- Trial: **0.493**
- Premium: **0.499**

This suggests that subscription status alone does not meaningfully separate the supplied risk score.

### Behavioral Segmentation

A stronger retention strategy is to combine:

- Churn Risk Score
- Engagement Score

This creates four practical groups:

1. High Risk + Low Engagement
2. High Risk + High Engagement
3. Low Risk + Low Engagement
4. Low Risk + High Engagement

The **High Risk + Low Engagement** group is the clearest candidate for targeted retention experiments.

### Age

The highest average session frequency is observed in the **35–44** age group at **7.60 sessions/day**.

The lowest is the **45–54** group at **7.37 sessions/day**.

The overall difference is small, so age does not appear to be a strong differentiator of session frequency in this dataset.

### Geography

The USA has the highest average session frequency at **7.53 sessions/day**, while the UK is lowest at **7.43**.

The difference is only **0.10 sessions/day**, indicating limited geographic variation.

### Device

Average session duration is:

- Android: **30.57 minutes**
- iOS: **30.33 minutes**

The difference is only **0.24 minutes**, suggesting broadly similar session depth across platforms.

### App Version

Version **1.2** has the largest record count at **4,084**, followed by version **2.1** at **4,075**.

App adoption alone is not enough to evaluate release performance. Engagement, ratings, and risk should also be compared across versions.

### Monthly Activity

Monthly login activity is broadly stable across most full months.

The highest monthly record count is **742 in October 2023**.

The final observed month, **June 2025**, contains only **20 records** and may represent a partial data extract or reporting cutoff. It should not be interpreted as a genuine collapse in product usage without further validation.

## Correlation Analysis

The measured behavioral variables have almost no linear correlation with the supplied Churn Risk Score.

| Variable | Correlation with Churn Risk |
|---|---:|
| Engagement Score | -0.004 |
| In App Purchases | -0.004 |
| Sessions Per Day | -0.002 |
| Avg Session Duration Min | -0.001 |
| User Rating | 0.001 |
| Push Notifications Clicked | 0.004 |
| Screens Viewed | 0.008 |

The largest absolute correlation is **Screens Viewed at 0.008**, which is negligible in linear terms.

This does not by itself prove that the risk score is invalid. A real validation requires observed outcomes such as inactivity, cancellation, downgrade, or renewal behavior.

## SQL Analysis Layer

The project includes a **MySQL 8+ SQL analysis layer**.

The SQL file contains:

- Database and raw table creation
- CSV import instructions
- Data-quality checks
- An analytics view
- Engagement Score calculation
- Age Group calculation
- Login Month calculation
- KPI queries
- Subscription analysis
- Churn-risk analysis
- Behavioral segmentation
- Country analysis
- Device analysis
- App-version analysis
- Push-notification analysis
- Monthly login trends
- Dashboard-ready summary queries

### Main SQL View

```text
vw_user_engagement_analysis
```

This view adds:

- `age_group`
- `login_month`
- `engagement_score`

to the original source fields.


## Tools & Technologies

- **Python**
- **Pandas**
- **NumPy**
- **Matplotlib**
- **Jupyter Notebook**
- **MySQL 8+**
- **SQL**
- **Power BI-ready analytical outputs**
- **PDF / Word reporting**

## How to Run the Python Analysis

1. Open the notebook:

```text
Mobile App User Engagement(1).ipynb
```

2. Place the CSV in the same working directory or update the notebook's file path.

3. Run the notebook cells from top to bottom.

4. The notebook performs data loading, validation, derived metric creation, grouped analysis, and visualization.

## How to Run the SQL Analysis

### 1. Open MySQL Workbench

Use MySQL 8+.

### 2. Open

```text
mobile_app_user_engagement_analysis.sql
```

### 3. Update the CSV path

The SQL file contains a `LOAD DATA LOCAL INFILE` statement.

Update the file path to wherever the CSV is stored.

### 4. Run the script

The script creates:

```text
mobile_app_analytics
```

and the source table:

```text
mobile_app_user_engagement
```

It then creates:

```text
vw_user_engagement_analysis
```

for repeatable analysis.

### 5. Run the business queries

The SQL file includes separate queries for KPIs, subscription, churn risk, segmentation, product usage, time trends, and dashboard extracts.

## Business Recommendations

### 1. Prioritize High Risk + Low Engagement

Use the behavioral segment to identify users who are both relatively disengaged and have elevated supplied risk.

Potential interventions:

- Re-engagement campaigns
- Product education
- Personalized messaging
- Incentive testing

### 2. Improve Trial-to-Premium Analysis

Trial users represent approximately one-third of the source records.

Actual Trial-to-Premium conversion cannot be calculated from the current data because conversion history is not available.

Add trial start, trial end, conversion, and subscription-event data in the next version.

### 3. Validate the Churn Risk Score

Connect the supplied risk score to actual downstream outcomes.

Potential validation metrics include:

- AUC
- Precision
- Recall
- Calibration
- Lift by risk band

### 4. Investigate June 2025

Confirm whether the unusually low number of June 2025 records is caused by:

- Partial extraction
- Reporting cutoff
- Missing data
- A genuine product event

### 5. Monitor App Versions

Compare versions using:

- Engagement
- Ratings
- Session duration
- Churn-risk distribution

rather than adoption alone.

### 6. Test Push Notifications

Measure whether notification exposure produces higher subsequent engagement or retention.

The current dataset supports descriptive analysis but not causal effectiveness measurement.

### 7. Build a Power BI Dashboard

Recommended dashboard slicers:

- Country
- Device Type
- Subscription Status
- Age Group
- App Version

The SQL analytics view can serve as a repeatable source for the dashboard.

## Limitations

The current project has several important limitations:

- No observed churn/cancellation label
- Custom Engagement Score weights are not business-outcome validated
- Monthly login counts are record counts, not guaranteed unique active users
- June 2025 may be a partial period
- Descriptive comparisons do not establish causality
- No cohort retention data
- No Trial-to-Premium event history
- No revenue or lifetime-value data
- Repeated User IDs mean record-level counts must be interpreted carefully

## Future Improvements

The next version of the project can add:

1. Actual churn or inactivity labels
2. Monthly Active Users using distinct User IDs
3. Retention cohorts
4. Trial-to-Premium conversion analysis
5. Revenue and Lifetime Value analysis
6. Risk-score validation against real outcomes
7. Predictive churn modeling
8. Power BI dashboard
9. Controlled retention experiments
10. Notification effectiveness testing

## Final Takeaway

The analysis shows a broadly consistent mobile-app engagement profile across major demographic, geographic, device, and subscription segments.

The most important finding is that **subscription status alone does not meaningfully distinguish the supplied churn-risk score**. A more useful approach is to combine risk and behavioral engagement to identify targeted retention segments.



