# startup-financial-performance-analysis
End-to-end SaaS financial and subscription analytics using MySQL and Power BI
# Startup Financial Performance & Subscription Analytics

## Project Overview

An end-to-end financial and subscription analytics project focused on evaluating the financial performance, customer distribution, subscription trends, payment behaviour, and retention patterns of a SaaS startup.

The project uses SQL for data analysis and Power BI to develop an interactive, three-page dashboard that translates raw business data into actionable insights.

## Business Objectives

- Evaluate active Monthly Recurring Revenue (MRR) and payment collections.
- Analyse payment success rates, failed transactions, and outstanding invoices.
- Understand customer distribution across regions, segments, and acquisition channels.
- Compare subscription performance and revenue contribution across pricing plans.
- Monitor subscription cancellations, monthly churn, and cohort retention.
- Identify potential areas for revenue improvement and customer retention.

## Tools & Technologies

- **MySQL:** Data exploration, cleaning, aggregation, joins, CTEs, subqueries, and window functions.
- **Power BI:** Data modelling, DAX measures, interactive dashboards, and visual analytics.
- **Excel:** Data inspection and supporting analysis.
- **Python:** Supporting data preparation and cohort analysis.

## Dataset Overview

The project uses five relational datasets:

| Dataset | Records |
|---|---:|
| Accounts | 5,000 |
| Subscriptions | 5,000 |
| Plans | 4 |
| Invoices | 85,448 |
| Payments | 87,287 |

An additional cohort retention dataset was used for retention visualisation in Power BI.

## Dashboard

The Power BI dashboard consists of three analytical pages:

### 1. Financial Performance
- Active MRR
- Successful payment collections
- Payment attempt success rate
- Outstanding invoice amount
- Monthly cash collections
- Invoice status and payment performance

### 2. Customer & Subscription Analytics
- Customer distribution by segment and region
- Acquisition channel analysis
- Active subscriptions by plan
- Monthly new subscription MRR
- Active versus cancelled subscriptions
- Average subscription MRR by segment

### 3. Retention & Churn
- Total cancelled subscriptions
- Overall cancellation rate
- Monthly churn trends
- Cohort retention heatmap
- 12-month cohort retention comparison

## Key Business Insights

### Financial & Payment Performance
- Active MRR stands at **1,387,441**.
- Successful payment collections total **27,639,401**.
- Payment attempt success rate is **91.77%**.
- Outstanding open invoice amount is **1,857,721**.
- All 5,311 open invoices were overdue at the time of the analysis.

### Customer & Subscription Performance
- SMB customers account for **70.44%** of all accounts.
- Enterprise and Scale plans contribute approximately **73.31% of active MRR**, despite representing only 19.11% of active subscriptions.
- Enterprise subscriptions have the highest average MRR among the plans.

### Retention & Churn
- There are **4,035 active subscriptions** and **965 cancelled subscriptions**.
- The overall cancelled subscription proportion is **19.3%**.
- The highest observed monthly churn rate was **1.95% in August 2024**.
- The best 12-month cohort retention was **91.49% for the January 2024 cohort**.

## Business Recommendations

1. **Improve payment recovery:** Investigate failed payment attempts and strengthen automated retry and customer notification processes.
2. **Reduce outstanding receivables:** Prioritise overdue invoices and improve payment follow-up.
3. **Focus on high-value plans:** Protect Enterprise and Scale customers through targeted retention and account management strategies.
4. **Improve customer retention:** Investigate cancellation patterns and identify opportunities to reduce churn.
5. **Strengthen acquisition measurement:** Track acquisition spending and customer lifetime value to evaluate channel profitability.

## Project Limitations

- The dataset does not provide acquisition spending, so actual CAC and LTV:CAC could not be calculated.
- Operating expenses and cash balance are unavailable, preventing burn-rate and runway calculations.
- The source currency is unspecified. INR formatting in the Power BI dashboard is an illustrative presentation assumption, not a verified source currency.
- Successful payment collections represent cash collected through payment transactions and should not be interpreted as recognised revenue.
- Active MRR represents the recorded MRR of active subscriptions.
- Retention analysis is based on subscription records and the available observation period.

## Repository Structure

```text
startup-financial-performance-analysis/
│
├── sql/
│   └── startup_financial_analysis.sql
│
├── powerbi/
│
├── report/
│
├── startup-analysis.pbix
├── Startup_Financial_Performance_Analysis_Report.pdf
├── README.md
└── .gitignore
```

*The dashboard and report files are also available in the repository. The folder structure can be updated as additional project files are organised.*

## Deliverables

- SQL analysis
