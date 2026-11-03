# Python Business Analysis
## Food Delivery Operations & Customer Analytics

### 1. Project Overview

This document presents the Python-based business analysis performed on the cleaned Food Delivery dataset using Pandas, NumPy, and Matplotlib.

The objective is to identify customer ordering patterns, understand hourly demand distribution, and derive insights that can support operational planning and resource allocation.

### 2. Tools & Libraries

- **Python 3.12.10:** Programming language used for analysis.
- **Pandas:** Data manipulation, grouping, aggregation, and analysis.
- **NumPy:** Numerical calculations and statistical comparisons.
- **Matplotlib:** Data visualization and presentation of findings.

### 3. Dataset

- **Source:** Cleaned project dataset.
- **File:** `data/cleaned/orders.csv`
- **Total Records:** 60,000 orders.
- **Columns:** 16

The cleaned dataset was used to ensure that the analysis was performed on validated data rather than the original raw records.

### 4. Business Analysis

#### 4.1 Order Volume by Day of the Week

**Business Question:** Which days of the week receive the highest and lowest order volumes?

**Approach:**

- Converted the `Order_Date` column into a datetime data type.
- Extracted weekday names using Pandas `.dt.day_name()`.
- Grouped orders by weekday.
- Counted orders using `Order_ID`.
- Sorted the results in descending order of order volume.

**Results:**

| Day | Total Orders |
|---|---:|
| Friday | 8,747 |
| Wednesday | 8,665 |
| Saturday | 8,599 |
| Monday | 8,573 |
| Tuesday | 8,554 |
| Thursday | 8,490 |
| Sunday | 8,372 |
| **Total** | **60,000** |

**Key Findings:**

- Friday recorded the highest order volume with 8,747 orders.
- Sunday recorded the lowest order volume with 8,372 orders.
- The difference between the busiest and quietest days was 375 orders, approximately 4.5% relative to Sunday's volume.
- Order demand remained relatively consistent throughout the week.

**Business Interpretation:**

The relatively small variation in weekday order volumes suggests that demand is distributed fairly evenly across the week.

Operational planning should therefore consider additional factors, such as hourly demand, delivery performance, and restaurant preparation capacity, rather than relying solely on weekday order volumes.

**Limitation:**

This analysis considers order volume only. It does not establish profitability, staffing requirements, or the reasons behind differences in customer ordering behaviour.

#### 4.2 Hourly Order Demand Analysis

**Business Question:** During which hours of the day do customers place the most and fewest orders?

**Approach:**

- Converted the `Order_Time` column into a datetime data type using the appropriate time format.
- Extracted the hour from each order using Pandas `.dt.hour`.
- Grouped orders by hour and counted the `Order_ID` values.
- Sorted the hourly results in descending order to identify peak and off-peak hours.
- Prepared a separate chronological view of the hourly results for visualisation.

**Hourly Order Distribution:**

| Hour | Total Orders |
|---:|---:|
| 00:00 | 2,411 |
| 01:00 | 2,522 |
| 02:00 | 2,491 |
| 03:00 | 2,532 |
| 04:00 | 2,492 |
| 05:00 | 2,484 |
| 06:00 | 2,537 |
| 07:00 | 2,455 |
| 08:00 | 2,434 |
| 09:00 | 2,510 |
| 10:00 | 2,541 |
| 11:00 | 2,499 |
| 12:00 | 2,522 |
| 13:00 | 2,425 |
| 14:00 | 2,557 |
| 15:00 | 2,592 |
| 16:00 | 2,497 |
| 17:00 | 2,564 |
| 18:00 | 2,551 |
| 19:00 | 2,420 |
| 20:00 | 2,517 |
| 21:00 | 2,510 |
| 22:00 | 2,495 |
| 23:00 | 2,442 |
| **Total** | **60,000** |

**Key Findings:**

- The busiest hour was 15:00-15:59, with 2,592 orders.
- The quietest hour was 00:00-00:59, with 2,411 orders.
- The difference between the busiest and quietest hours was 181 orders.
- Order volume was relatively evenly distributed across the 24 hours.

**NumPy Analysis - Peak vs Average Demand**

NumPy was used to calculate the average and maximum hourly order volumes.

| Metric | Result |
|---|---:|
| Average hourly orders | 2,500 |
| Maximum hourly orders | 2,592 |
| Peak above average | 92 |
| Peak uplift over average | 3.68% |

**Visualisation:**

A Matplotlib line chart was created to display hourly order demand in chronological order from 00:00 to 23:00.

The chart helps identify variations in hourly order volume and highlights the busiest and quieter periods.

**Business Interpretation:**

The analysis indicates that hourly demand remains relatively consistent, with a modest increase during the 15:00–15:59 period.

The busiest hour exceeds average hourly demand by only 3.68%. Therefore, the business should avoid making major staffing decisions based solely on order volume.

Hourly demand should be considered alongside delivery performance, restaurant preparation time, and delivery partner availability.

**Validation:**

- Total hourly order counts: 60,000.
- Original cleaned orders: 60,000.
- The hourly aggregation reconciles with the original dataset.

**Limitation:**

This analysis identifies order placement patterns but does not establish actual delivery workload, staffing requirements, profitability, or the reasons behind hourly demand fluctuations.