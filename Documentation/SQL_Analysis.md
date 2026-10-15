# Food Delivery Operations & Customer Analytics

## SQL Analysis Documentation

### 1. Project Objective

Use SQL to analyse food delivery operations and customer behaviour, identify business trends, and generate actionable insights.

### 2. Database Details

- **Database:** `food_delivery_analytics`
- **Tool:** MySQL Workbench
- **Data Source:** Cleaned CSV datasets exported from Python.

### 3. Database Tables

The database contains seven tables:

- `customers`
- `restaurants`
- `delivery_partners`
- `orders`
- `deliveries`
- `reviews`
- `data_dictionary`

### 4. Data Import and Validation

All seven tables were loaded into MySQL Workbench. The imported record counts were checked against the expected dataset sizes.

| Table | Records |
|---|---:|
| Customers | 2,500 |
| Restaurants | 238 |
| Delivery Partners | 700 |
| Orders | 60,000 |
| Deliveries | 55,450 |
| Reviews | 34,379 |
| Data Dictionary | 16 |
| **Total** | **153,283** |

### 5. SQL Analysis Progress

Database loading and the first round of business analysis are complete through Task 5.5. Analysis has covered order volume and status, final order amounts, average order value, monthly order trends, delivery delay, and delivery performance by distance. Customer satisfaction analysis is the next planned area.

### 6. Business Analysis Areas

- Order trends and status distribution
- Revenue and order value
- Order cancellations
- Delivery performance
- Restaurant performance
- Customer behaviour and reviews

### 7. Findings and Recommendations

Initial findings from the completed analysis include:

- 92.42% of orders were delivered and 7.58% were cancelled.
- The total final amount across all orders was 28,891,412.88; the amount associated with delivered orders was 26,666,422.15. The delivered-order amount is an initial completed-sales measure, not a confirmed accounting revenue figure.
- Cancelled orders had a slightly higher average final amount than delivered orders.
- Monthly order volume varies over time. Further analysis is needed before making claims about seasonality.
- The average delay among deliveries whose actual duration exceeded the estimate was approximately 18.44 minutes.
- Average actual delivery time exceeded average estimated delivery time across all distance bands. The Very Long band had the largest difference between the two averages, at approximately 17 minutes.

These are descriptive findings. Further analysis is needed to understand causes and determine appropriate operational actions.

### 8. Order Volume and Status Analysis

**Objective**

Calculate total order volume and understand the distribution of delivered and cancelled orders.

**Approach**

Used three SQL aggregate queries with `COUNT()` to calculate total orders and count orders filtered by their status.

**Results**

| Metric | Count | Percentage |
|---|---:|---:|
| Total Orders | 60,000 | 100.00% |
| Delivered Orders | 55,450 | 92.42% |
| Cancelled Orders | 4,550 | 7.58% |

**Observation**

The dataset contains 60,000 orders. Approximately 92.42% were delivered, while 7.58% were cancelled.

**Business Relevance**

These metrics establish a baseline for monitoring order fulfilment and cancellations. Further analysis can investigate cancellation patterns and identify potential operational improvements.


### 9. Revenue Analysis

**Objective**

Calculate the total final order amount and compare the amounts associated with delivered and cancelled orders.

**Approach**

Used the `SUM()` aggregate function on `Final_Amount`. Separate queries filtered orders by `Order_Status` to calculate the amounts for delivered and cancelled orders.

**Results**

| Metric | Amount |
|---|---:|
| Total final amount across all orders | 28,891,412.88 |
| Delivered-order final amount | 26,666,422.15 |
| Cancelled-order final amount | 2,224,990.73 |

**Observation**

The final amounts associated with delivered and cancelled orders reconcile to the total amount across all orders.

**Business Relevance**

Separating delivered and cancelled orders helps distinguish completed sales from amounts associated with cancelled transactions. 

### 10. Average Order Value Analysis

**Objective**

Calculate the average final order amount across all orders and compare the averages for delivered and cancelled orders.

**Approach**

Used the `AVG()` aggregate function on `Final_Amount`, with separate calculations for all orders, delivered orders, and cancelled orders.

**Results**

| Metric | Average Final Amount |
|---|---:|
| All Orders | ₹481.52 |
| Delivered Orders | ₹480.91 |
| Cancelled Orders | ₹489.01 |

**Observation**

Cancelled orders have a higher average final amount than delivered orders, although the difference is relatively small.

**Business Relevance**

Comparing average order values across statuses can help identify patterns worth investigating. Further analysis is needed before drawing conclusions about the relationship between order value and cancellations.


### 11. Monthly Order Trends

**Objective**

Analyse monthly order volume over time.

**Business Question**

How does the number of orders change from month to month?

**Approach**

Used `DATE_FORMAT(Order_Date, '%Y-%m')` to group orders by year and month, counted orders for each month, and sorted the results chronologically.

**Observation**

Monthly order volume varies over time, with noticeable changes between consecutive months. For example, the visible results showed 1,145 orders in February 2025 and 1,319 in March 2025. A complete seasonal pattern should not be inferred from this observation alone.

**Business Relevance**

Monthly order trends can help identify demand changes and support staffing, delivery capacity, and operational planning.

### 12. Delivery Time Analysis

**Objective**

Measure the actual time taken to complete deliveries.

**Approach**

Joined `orders` to `deliveries` by `Order_ID` and calculated the average `Actual_Delivery_Min` for orders marked as delivered.

**Result**

The average actual delivery time for delivered orders was approximately **58.05 minutes**.

**Business Relevance**

This establishes a baseline for delivery duration. It measures actual delivery duration, not the time elapsed between placing an order and receiving it.

### 13. On-Time Delivery Performance

**Objective**

Understand the distribution of delivery records by their recorded status.

**Results**

| Recorded Delivery Status | Count | Percentage of delivery records |
|---|---:|---:|
| On Time | 7,297 | 13.16% |
| Delayed | 48,153 | 86.84% |
| **Total** | **55,450** | **100.00%** |

**Observation**

Most delivery records were labelled `Delayed`. The recorded status was subsequently checked against the estimated and actual delivery times.

**Business Relevance**

The status distribution provides an initial view of recorded delivery reliability. The status label should be interpreted alongside the time fields.

### 14. Delivery Status Consistency Check

**Objective**

Compare the original `Delivery_Status` with a classification based on estimated and actual delivery duration.

**Proposed time-based rule**

- If `Actual_Delivery_Min` is less than or equal to `Estimated_Delivery_Min`, classify the delivery as `On Time`.
- If `Actual_Delivery_Min` is greater than `Estimated_Delivery_Min`, classify the delivery as `Delayed`.

**Results**

| Original Status | Time-based condition | Count |
|---|---|---:|
| On Time | Actual time ≤ estimated time | 7,297 |
| On Time | Actual time > estimated time | 0 |
| Delayed | Actual time ≤ estimated time | 21 |
| Delayed | Actual time > estimated time | 48,132 |
| **Total** |  | **55,450** |

**Observation**

There were 21 records labelled `Delayed` even though actual delivery duration was less than or equal to the estimated duration. No records labelled `On Time` exceeded the estimated duration. Under this proposed rule, 55,429 of 55,450 records (approximately 99.96%) matched the time-based classification.

**Limitation**

This check tests consistency between the status label and the recorded time fields. It does not prove that the time values themselves are accurate. The original `Delivery_Status` values have not been overwritten.

### 15. Average Delay Duration

**Objective**

Measure how many minutes late deliveries were when actual delivery duration exceeded the estimate.

**Approach**

Calculated `Actual_Delivery_Min - Estimated_Delivery_Min` and averaged the difference only for records where actual duration was greater than estimated duration.

**Result**

The average delay duration was approximately **18.44 minutes** among deliveries that exceeded their estimated duration.

**Business Relevance**

This quantifies lateness for deliveries that took longer than estimated and provides a baseline for further investigation into delivery performance.

### 16. Delivery Performance by Distance

**Objective**

Compare delivery volume, estimated duration, and actual duration across distance bands.

**Approach**

Created distance bands using a `CASE` expression:

- Short: distance ≤ 2 km
- Medium: distance > 2 km and ≤ 5 km
- Long: distance > 5 km and ≤ 8 km
- Very Long: distance > 8 km

Calculated delivery count, average estimated delivery time, and average actual delivery time for each band. Average times were rounded to whole minutes in the query output.

**Results**

| Distance Band | Deliveries | Average Estimated Time (min) | Average Actual Time (min) | Difference between averages (min) |
|---|---:|---:|---:|---:|
| Short | 8,222 | 43 | 58 | 15 |
| Medium | 21,466 | 42 | 57 | 15 |
| Long | 14,116 | 42 | 57 | 15 |
| Very Long | 11,646 | 43 | 60 | 17 |
| **Total** | **55,450** |  |  |  |

**Observation**

Average estimated delivery time ranged from 42 to 43 minutes, while average actual delivery time ranged from 57 to 60 minutes. The Very Long distance band had the highest average actual duration and the largest gap between the rounded group averages, at approximately 17 minutes.

**Interpretation and limitation**

The results do not show a steady increase in average actual delivery time across every distance band. Distance alone may not explain delivery duration. The difference shown is between group averages; it is not the same as the average of individual delivery delays calculated in Task 5.4.

**Business Relevance**

Comparing estimated and actual duration across distance bands can help identify where delivery estimates or operations may warrant further investigation.

### 17. Next Analysis Area: Customer Satisfaction

The next planned task is to analyse the `reviews` table, beginning with average customer rating and then examining the distribution of ratings. Results will be added after the SQL queries have been run and verified.
