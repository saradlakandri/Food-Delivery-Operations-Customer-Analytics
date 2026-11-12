# Food Delivery Operations & Customer Analytics

An end-to-end data analytics project focused on understanding food delivery operations, customer ordering behaviour, restaurant performance and delivery efficiency using **Excel, SQL, Python and Power BI**.

## Project Overview

This project analyses food delivery data to identify operational trends, evaluate business performance and generate insights that can support data-driven decision-making.

The analysis covers the complete workflow, from data inspection and cleaning to SQL-based business analysis, Python exploration and interactive Power BI dashboard development.

## Business Objectives

- Understand order volume, delivery completion and cancellation patterns.
- Analyse order value and delivered-order performance.
- Evaluate restaurant performance using order volume, delivered value, ratings and cancellation rates.
- Examine delivery efficiency, delays and the relationship between delivery distance and actual delivery time.
- Understand customer segments, repeat ordering behaviour and customer acquisition trends.
- Present key findings through interactive dashboards.

## Tools & Technologies

| Tool | Purpose |
|---|---|
| Microsoft Excel | Data inspection and supporting analysis |
| MySQL | Data validation, querying and business analysis |
| Python | Data cleaning, manipulation, statistical analysis and visualisation |
| Pandas | Data processing and aggregation |
| NumPy | Numerical and statistical calculations |
| Matplotlib / Seaborn | Data visualisation |
| Power BI | Data modelling, DAX measures and interactive dashboards |
| Git & GitHub | Version control and project management |

## Dataset Overview

The project uses seven related datasets:

| Dataset | Records |
|---|---:|
| Customers | 2,500 |
| Restaurants | 250 |
| Delivery Partners | 700 |
| Orders | 60,000 |
| Deliveries | 55,450 |
| Reviews | 34,379 |
| Data Dictionary | 16 |

The datasets contain information about customers, orders, restaurants, delivery partners, delivery performance and customer reviews.

## Project Workflow

### 1. Data Inspection & Cleaning

- Inspected the raw datasets and their structure.
- Reviewed data types, missing values, duplicates and inconsistent records.
- Investigated data-quality issues, including unusual delivery durations and discount-related inconsistencies.
- Prepared cleaned datasets for downstream analysis.

### 2. SQL Analysis

Used MySQL to validate the imported datasets and answer business questions through filtering, aggregation, joins and other SQL operations.

Analysis areas included:

- Order volume and status distribution.
- Delivered and cancelled order amounts.
- Average order value.
- Monthly order trends.
- Delivery performance and delay analysis.
- Restaurant performance.
- Customer behaviour and review analysis.

**Detailed documentation:** [SQL Analysis](Documentation/SQL_Analysis.md)

### 3. Python Analysis

Used Python to explore ordering patterns, customer behaviour and delivery performance.

Key analysis areas included:

- Order volume by weekday and hour.
- Peak and off-peak demand.
- Delivery distance versus actual delivery duration.
- Investigation of unusually short delivery durations.
- Customer-level ordering frequency and repeat customer classification.

**Detailed documentation:** [Python Analysis](Documentation/Python_Analysis.md)

### 4. Power BI Dashboard

Developed an interactive Power BI report containing four analytical pages.

| Dashboard Page | Focus |
|---|---|
| Executive Overview | Overall business performance, order trends and customer segment contribution |
| Restaurant Performance | Restaurant rankings, delivered orders, delivered value, ratings and cancellation rates |
| Delivery Operations | Delivery status, actual delivery time, delays and vehicle-type performance |
| Customer Insights | Customer segments, repeat customers, order frequency and customer acquisition |

The report includes KPI cards, charts and interactive slicers for exploring the data by relevant business dimensions.

## Dashboard Preview

The following dashboard pages provide an overview of the interactive Power BI report.

### 1. Executive Overview

![Executive Overview](Documentation/Images/executive-overview.png)

### 2. Restaurant Performance

![Restaurant Performance](Documentation/Images/restaurant-performance.png)

### 3. Delivery Operations

![Delivery Operations](Documentation/Images/delivery-operations.png)

### 4. Customer Insights

![Customer Insights](Documentation/Images/customer-insights.png)

**Dashboard resources:**

- [Open the Power BI Dashboard File](Power%20BI/Food_Delivery_Operations_Customer_Analytics.pbix)
- [Read the Power BI Dashboard Guide](Documentation/PowerBI_Dashboard_Guide.md)

*Note: Download the PBIX file and open it using Microsoft Power BI Desktop.*

## Key Findings

### Order Performance

- 60,000 orders were recorded.
- 55,450 orders were delivered, representing **92.42%** of total orders.
- 4,550 orders were cancelled, representing **7.58%**.
- The total final order amount for delivered orders was approximately **₹26.67 million**.

### Delivery Operations

- Average actual delivery time was approximately **58.05 minutes**.
- Average delay among deliveries that exceeded their estimated duration was approximately **18.44 minutes**.
- The correlation between delivery distance and actual delivery time was **0.07**, indicating a very weak positive linear relationship.
- Twenty-five unusually short delivery records were identified for further validation. These records were retained without modification.

### Customer Behaviour

- The dataset contains **2,500 customers**.
- Python customer-level analysis classified all 2,500 customers as repeat customers within the available dataset.
- Average and median order frequency were both **24 orders per customer**.
- Individual customer order counts ranged from **10 to 40**.

## Repository Structure

```text
Food-Delivery-Operations-Customer-Analytics/
│
├── Documentation/
│   ├── SQL_Analysis.md
│   ├── Python_Analysis.md
│   ├── PowerBI_Dashboard_Guide.md
│   └── images/
│       ├── executive-overview.png
│       ├── restaurant-performance.png
│       ├── delivery-operations.png
│       └── customer-insights.png
│
├── Power BI/
│   └── Food_Delivery_Operations_Customer_Analytics.pbix
│
├── Python/
│   ├── 01_data_audit.py
│   ├── 02_business_analysis.py
│   └── Food_Delivery_Operations_Customer_Analytics.ipynb
│
├── SQL/
│   ├── 02_data_validation.sql
│   └── 03_business_analysis.sql
│
├── Visualization/
│
├── data/
│   └── cleaned/
│
├── .gitignore
└── README.md
```

## Business Value

This project demonstrates how data from multiple business areas can be analysed and presented in a structured way.

The findings help highlight:

- Order fulfilment and cancellation patterns.
- Differences in restaurant performance.
- Delivery delays and operational efficiency.
- Customer ordering frequency and segment contribution.
- Areas that may require further investigation and operational improvement.

## Project Limitations

- The analysis is based on the available project dataset and may not represent the behaviour of a real-world food delivery business.
- The findings are primarily descriptive and do not establish the causes of operational outcomes.
- Delivered-order final amount is used as a completed-sales measure; it should not be interpreted as confirmed accounting revenue or profit.
- Unusual delivery records were retained rather than altered without supporting evidence.

## Author

**Sarad Lakandri**

Data Analytics | SQL | Python | Power BI | Excel

[GitHub Profile](https://github.com/saradlakandri)

[Project Repository](https://github.com/saradlakandri/Food-Delivery-Operations-Customer-Analytics)
