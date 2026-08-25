# 📊 User Engagement & Churn Analysis

## 📌 Project Overview

This project analyzes user engagement, subscription behavior, app usage, and churn risk using a dataset of **20,000 users**.

The objective is to understand how users interact with the application, identify differences across user segments, and uncover patterns that may help improve **user retention, engagement, and subscription conversion**.

The analysis was performed using Python with a focus on exploratory data analysis (EDA), statistical summaries, and data visualization.

---

## 🎯 Business Objectives

The project aims to answer questions such as:

- How actively are users engaging with the application?
- How does engagement vary across age groups and countries?
- Which subscription types have the highest user share?
- How is churn risk distributed among Free, Trial, and Premium users?
- Which app versions have the largest user base?
- How do Android and iOS users compare in session duration?
- How have monthly user logins changed over time?
- How frequently do users interact with push notifications?
- What does the user rating distribution look like?

---

## 📂 Dataset

The dataset contains **20,000 users** with information related to:

- User engagement
- Session activity
- App usage
- Subscription type
- Churn risk
- User ratings
- Device type
- Country
- Age group
- App version
- Push notification interactions
- Monthly login activity

### Key Variables

| Variable | Description |
|---|---|
| Session Duration | Time spent during user sessions |
| Screens Viewed | Number of screens viewed |
| In-App Purchases | Number/value of in-app purchases |
| Engagement Score | Overall user engagement score |
| Churn Risk Score | Estimated probability/risk of user churn |
| Rating | User rating from 1 to 5 |
| Subscription Type | Free, Trial, or Premium |
| Age Group | User age category |
| Country | User's country |
| App Version | Version of the application used |
| Device Type | Android or iOS |
| Push Notifications Clicked | Number of push notifications interacted with |
| Monthly Logins | Number of users logging in each month |

---

## 🛠️ Tools & Technologies

- **Python**
- **Pandas**
- **NumPy**
- **Matplotlib**
- **Seaborn**
- **Jupyter Notebook**

---

# 🔍 Exploratory Data Analysis

## 1. User Engagement Metrics

The project analyzes several important engagement metrics:

- Average session duration
- Screens viewed
- In-app purchases
- Engagement score
- Churn risk score
- User ratings

These distributions help understand how users interact with the application and how engagement varies across the user base.

---

## 2. Monthly User Logins

Monthly login activity was analyzed from **January 2023 to June 2025**.

The number of monthly logins generally remains within the **600–750 range**, showing relatively stable user activity throughout most of the period.

### Key observations

- Highest recorded monthly login count: **742**
- Lowest full-month count: **625**
- User activity remained relatively stable throughout 2023 and 2024.
- Login activity peaked around late 2023 and remained strong during much of 2024.
- June 2025 shows only **20 logins**, which may indicate an incomplete month or partial data.

This type of analysis can help identify seasonal patterns and potential changes in user retention.

---

## 3. Subscription Distribution

Users are divided into three subscription categories:

| Subscription Type | Approx. Share |
|---|---:|
| Premium | 33.8% |
| Free | 33.3% |
| Trial | 32.9% |

The distribution is remarkably balanced, with each subscription category representing approximately one-third of the user base.

### Insight

The relatively large Trial segment presents an opportunity to analyze **trial-to-paid conversion** and identify factors that influence users to upgrade to Premium.

---

## 4. Average Sessions by Age Group

Average daily sessions were compared across age groups.

| Age Group | Avg. Sessions/Day |
|---|---:|
| <18 | 7.50 |
| 18–24 | 7.51 |
| 25–34 | 7.40 |
| 35–44 | 7.60 |
| 45–54 | 7.37 |
| 55–64 | 7.48 |
| 65+ | Data not prominently represented |

### Key Insight

Engagement is fairly consistent across age groups, with users aged **35–44 showing the highest average session frequency at approximately 7.60 sessions per day** among the displayed groups.

This suggests that age alone may not be a major differentiator of engagement.

---

## 5. Average Sessions by Country

User engagement was also compared across countries.

| Country | Avg. Sessions/Day |
|---|---:|
| USA | 7.53 |
| Brazil | 7.51 |
| Germany | 7.48 |
| Australia | 7.46 |
| Canada | 7.45 |
| India | 7.45 |
| UK | 7.43 |

### Key Insight

Average sessions per day are very similar across countries, ranging from approximately **7.43 to 7.53**.

The USA has the highest average session frequency among the displayed countries.

---

## 6. Churn Risk by Subscription Type

The distribution of churn risk scores was analyzed for:

- Free users
- Trial users
- Premium users

The violin plot shows that churn risk is distributed across a wide range for all three subscription types.

### Key Insight

All subscription categories show users with both low and high churn risk.

This indicates that **subscription type alone is not enough to identify users likely to churn**. Combining churn risk with engagement metrics, session activity, purchases, and other behavioral features could provide stronger insights.

---

## 7. Push Notification Engagement

The project analyzes the number of push notifications clicked by users.

Users interacted with between **0 and 9 push notifications** in the displayed distribution.

The number of users in each category remains relatively consistent, with approximately **1,900–2,100 users** per category.

### Insight

Push notification interaction is fairly evenly distributed, suggesting that notification engagement is not concentrated in only a small subset of users.

Further analysis could investigate whether users who click more notifications also have:

- Higher engagement scores
- Longer sessions
- Lower churn risk
- More purchases

---

## 8. App Version Distribution

The user base was also analyzed by application version.

| App Version | Users |
|---|---:|
| 1.0 | 3,926 |
| 1.1 | 3,980 |
| 1.2 | 4,084 |
| 2.0 | 3,935 |
| 2.1 | 4,075 |

### Key Insight

Version **1.2** has the largest user base with **4,084 users**, closely followed by version **2.1** with **4,075 users**.

The relatively even distribution across versions suggests that users are spread fairly consistently across the available application releases.

---

## 9. Session Duration by Device

Average session duration was compared between Android and iOS users.

| Device | Avg. Session Duration |
|---|---:|
| Android | 30.57 minutes |
| iOS | 30.33 minutes |

### Key Insight

Android users have a slightly higher average session duration than iOS users.

However, the difference is very small, suggesting that **device type has limited impact on session duration** in this dataset.

---

## 10. User Ratings

The distribution of user ratings from **1 to 5** was analyzed.

The ratings are distributed across the full scale, with the largest concentration around the higher rating values.

A rating of **3** has the highest displayed frequency, followed by ratings around **4–5**.

This provides an opportunity to investigate whether user satisfaction is associated with engagement, subscription status, or churn risk.

---

# 📈 Key Business Insights

Based on the analysis:

### 1. Engagement is relatively stable

Average sessions per day remain close to **7.4–7.6** across different age groups and countries.

### 2. Subscription distribution is balanced

Free, Trial, and Premium users each represent roughly one-third of the user base.

### 3. Churn risk varies within every subscription group

Both Free and Premium users can have high churn-risk scores, meaning retention strategies should be based on **behavior rather than subscription type alone**.

### 4. User activity is relatively stable

Monthly logins remain mostly within the **600–750 range** across the observed period, excluding the unusually low June 2025 value.

### 5. Device engagement is almost identical

Android and iOS users have very similar average session durations:

- Android: **30.57 minutes**
- iOS: **30.33 minutes**

### 6. Geographic differences are small

The difference in average daily sessions between the highest and lowest displayed countries is only around **0.10 sessions per day**.

### 7. App versions have similar adoption

No single app version dominates the user base, although versions **1.2 and 2.1** have the largest user counts.

---

# 📊 Visualizations

The project includes visualizations for:

- User engagement metric distributions
- Monthly user logins
- Push notification interactions
- Subscription type distribution
- Average sessions by age group
- Churn risk by subscription type
- Average sessions by country
- User count by app version
- Average session duration by device type
- User rating distribution

These visualizations make it easier to identify trends, differences between user segments, and potential areas for further investigation.

---

# 💡 Potential Business Recommendations

Based on the exploratory analysis, several areas could be investigated further:

### Improve Trial Conversion

Since Trial users represent roughly one-third of the user base, analyzing their behavior before and after the trial period could help identify opportunities to increase Premium conversions.

### Target High-Risk Users

Instead of applying the same retention strategy to everyone, users with high churn-risk scores could be segmented based on engagement and purchase behavior.

### Analyze Notification Effectiveness

Push notification clicks could be compared with engagement and churn metrics to determine whether notifications are actually improving retention.

### Investigate User Satisfaction

Ratings could be analyzed against churn risk, subscription type, and session duration to understand whether satisfaction influences retention.

### Monitor New App Versions

Tracking engagement and churn by app version could help determine whether newer releases improve the user experience.

---

# 📁 Project Structure

```text
User-Engagement-Churn-Analysis/
│
├── User_Engagement_Analysis.ipynb
├── dataset.csv
├── visualizations/
│   ├── engagement_metrics.png
│   ├── monthly_logins.png
│   ├── subscription_distribution.png
│   ├── churn_risk.png
│   └── ...
│
└── README.md
