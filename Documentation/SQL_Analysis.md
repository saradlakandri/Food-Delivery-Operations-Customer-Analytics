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

SQL analysis has been completed for order volume and status, final order amounts, average order value, monthly order trends, delivery performance, and customer satisfaction. Restaurant performance analysis is now underway, beginning with order volume and followed by delivered-order value and cancellation rate.

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

### 17. Customer Satisfaction Analysis

**Objective**

Analyse customer ratings to understand satisfaction with the food delivery service.

**Business Question**

What ratings are customers giving, and what does the rating distribution tell us about customer satisfaction?

**Business Relevance**

Identify satisfaction patterns and potential areas for service improvement.

#### 17.1 Average Customer Rating

**Approach**

Used the `AVG()` aggregate function on the `Rating` column in the `reviews` table.

**Result**

The average recorded customer rating was approximately **3.86 out of 5**.

**Business Insight**

The average rating establishes an overall customer-rating baseline. However, the average alone does not show whether ratings are concentrated around the middle or split between very high and very low scores.

#### 17.2 Customer Rating Distribution

**Approach**

Counted review records for each recorded rating using `COUNT()` and `GROUP BY`, then sorted the results in ascending order of rating.

**Results**

| Rating | Number of Reviews |
|---:|---:|
| 0 | 12 |
| 1 | 1,406 |
| 2 | 2,756 |
| 3 | 5,443 |
| 4 | 14,258 |
| 5 | 10,496 |
| 6 | 8 |
| **Total** | **34,379** |

**Observations**

- Rating 4 was the most frequent, with 14,258 reviews.
- Rating 5 was the second most frequent, with 10,496 reviews.
- The dataset contains 12 reviews rated 0 and 8 reviews rated 6, although the expected rating scale appears to be 1-5

**Data Quality Note**

The 20 records with ratings outside the expected 1-5 range require investigation before final satisfaction percentages are reported. The original data should not be changed without establishing an appropriate correction or exclusion rule.

#### 17.3 Rating Data Quality Check

**Objective**

Investigate reviews with ratings outside the expected 1–5 scale.

**Approach**

Filtered the `reviews` table for ratings below 1 or above 5, then counted the records for each unexpected rating.

**Results**

| Rating | Number of Reviews |
|---:|---:|
| 0 | 12 |
| 6 | 8 |
| **Total** | **20** |

**Observation**

Out of 34,379 reviews, 20 records (approximately 0.06%) contain ratings outside the expected 1–5 range.

**Business Insight**

Although these records represent a small proportion of the dataset, they should be investigated before final customer satisfaction reporting.

**Limitation**

The available analysis confirms that these ratings are outside the expected range but does not establish why they occurred. The original records should remain unchanged until an appropriate handling rule is determined.

#### 17.4 Customer Satisfaction by Rating Category

**Objective**

Analyse average customer ratings across different review categories.

**Approach**

Grouped reviews by `Review_Category` and calculated the average `Rating`, including only ratings between 1 and 5. The original rating data was left unchanged.

**Results**

| Review Category | Average Rating |
|---|---:|
| Food Quality | 3.86 |
| Delivery | 3.87 |
| Overall | 3.87 |
| Packaging | 3.86 |

**Business Insights**

- Delivery and Overall received the highest average ratings at 3.87.
- Food Quality and Packaging averaged 3.86.
- The average ratings are very similar across all four categories.

**Limitation**

The averages are rounded to two decimal places. The small differences do not establish a meaningful performance gap between categories. Further analysis of low ratings may help identify specific service issues.

#### 17.5 Low-Rating Analysis

**Objective**

Identify review categories with higher numbers of low ratings.

**Approach**

Counted reviews rated 1 or 2 in each `Review_Category`, including only valid ratings between 1 and 5.

**Results**

| Review Category | Low-Rated Reviews (1–2) |
|---|---:|
| Food Quality | 1,473 |
| Overall | 1,051 |
| Delivery | 1,015 |
| Packaging | 623 |
| **Total** | **4,162** |

**Business Insights**

Food Quality had the highest number of low-rated reviews, followed by Overall, Delivery, and Packaging.

**Limitation**

These are raw counts and do not account for differences in total review volume by category. A category with more reviews may naturally have more low-rated reviews.

**Next Step**

Calculate the percentage of low-rated reviews within each category to enable a fairer comparison.

#### 17.6 Low-Rating Percentage by Category

**Objective**

Compare the proportion of low ratings across review categories.

**Approach**

Used conditional aggregation to count reviews rated 1 or 2, divided by the total valid reviews in each category, and multiplied by 100. Only ratings between 1 and 5 were included.

**Results**

| Review Category | Total Valid Reviews | Low-Rated Reviews (1–2) | Low-Rating Percentage |
|---|---:|---:|---:|
| Food Quality | 11,963 | 1,473 | 12.31% |
| Overall | 8,656 | 1,051 | 12.14% |
| Delivery | 8,546 | 1,015 | 11.88% |
| Packaging | 5,194 | 623 | 11.99% |
| **Total** | **34,359** | **4,162** | **12.12%** |

**Business Insights**

Food Quality had the highest low-rating percentage at 12.31%, while Delivery had the lowest at 11.88%. The differences between categories are small, so the results should be interpreted cautiously.

**Business Relevance**

These percentages allow a fairer comparison than raw counts alone and can help identify service areas for further investigation.

#### 17.7 High-Rating Analysis

**Objective**

Measure the proportion of high ratings across review categories.

**Approach**

Used conditional aggregation to count reviews rated 4 or 5, divided by the total valid reviews in each category, and multiplied by 100. Only ratings between 1 and 5 were included.

**Results**

| Review Category | Total Valid Reviews | High-Rated Reviews (4–5) | High-Rating Percentage |
|---|---:|---:|---:|
| Food Quality | 11,963 | 8,595 | 71.85% |
| Overall | 8,656 | 6,269 | 72.42% |
| Delivery | 8,546 | 6,140 | 71.85% |
| Packaging | 5,194 | 3,750 | 72.20% |
| **Total** | **34,359** | **24,754** | **72.05%** |

**Business Insights**

Overall had the highest high-rating percentage at 72.42%, while Food Quality and Delivery each recorded 71.85%. Approximately 72.05% of all valid reviews were rated 4 or 5.

**Business Relevance**

High-rating percentages help identify categories receiving stronger customer feedback. Comparing these results with the low-rating percentages provides a more balanced view of customer satisfaction.


#### 17.8 Comparison of High and Low Ratings

**Objective**

Compare high and low customer ratings across review categories.

**Approach**

Calculated total valid reviews, counts of ratings 1–2 and 4–5, and their percentages for each review category. Only ratings between 1 and 5 were included.

**Results**

| Review Category | Total Valid Reviews | Low-Rated (1–2) | High-Rated (4–5) | Low-Rating % | High-Rating % |
|---|---:|---:|---:|---:|---:|
| Food Quality | 11,963 | 1,473 | 8,595 | 12.31% | 71.85% |
| Overall | 8,656 | 1,051 | 6,269 | 12.14% | 72.42% |
| Delivery | 8,546 | 1,015 | 6,140 | 11.88% | 71.85% |
| Packaging | 5,194 | 623 | 3,750 | 11.99% | 72.20% |

**Business Insights**

- Overall had the highest high-rating percentage at 72.42%.
- Food Quality had the highest low-rating percentage at 12.31%.
- Delivery had the lowest low-rating percentage at 11.88%.
- The differences between categories were relatively small.

**Business Relevance**

Comparing high and low ratings provides a balanced view of customer feedback and helps identify categories for further investigation.

**Limitation**

These results describe the recorded ratings. They do not establish the reasons behind customer satisfaction or dissatisfaction.


### Task 18 Restaurant Performance Analysis

#### Task 18.1 Top 10 Restaurants by Order Volume

**Objective:** Identify restaurants receiving the highest number of orders.

**Approach:** Joined the `orders` and `restaurants` tables using `Restaurant_ID`, counted orders for each restaurant, sorted the results in descending order, and selected the top 10.

**Key Findings:**
- Urban House 150 and Street Hub 065 ranked jointly first, with 282 orders each.
- Spice Kitchen 178 ranked third with 276 orders.
- The top 10 restaurants recorded between 266 and 282 orders each.

**Business Insight:** Order volume helps identify restaurants with high customer demand. Further analysis of completed-order value and cancellation rates is required before drawing conclusions about overall restaurant performance.

**Limitation:** This analysis includes all order statuses, including cancelled orders. A high order count does not necessarily mean high completed sales or profitability.

#### 18.2 Restaurant Performance Comparison

**Objective**

Compare restaurant order volume, delivered and cancelled orders, delivered-order value, and cancellation rate.

**Approach**

Joined the `orders` and `restaurants` tables using `Restaurant_ID`. Used conditional aggregation to count delivered and cancelled orders, calculated delivered-order value using `Final_Amount` for delivered orders only, and calculated cancellation rate as cancelled orders divided by total orders multiplied by 100. Results were sorted by total order volume in descending order, with delivered-order value as the secondary sort, and limited to the top 10 restaurants.

**Results**

| Restaurant | Total Orders | Delivered Orders | Cancelled Orders | Delivered-Order Value | Cancellation Rate |
|---|---:|---:|---:|---:|---:|
| Urban House 150 | 282 | 265 | 17 | 131,340.72 | 6.03% |
| Street Hub 065 | 282 | 258 | 24 | 121,169.24 | 8.51% |
| Spice Kitchen 178 | 276 | 254 | 22 | 116,588.42 | 7.97% |
| Taste Bites 078 | 274 | 262 | 12 | 119,727.52 | 4.38% |
| Urban Kitchen 085 | 271 | 250 | 21 | 113,452.37 | 7.75% |
| Food Kitchen 019 | 269 | 248 | 21 | 126,210.86 | 7.81% |
| Street Bites 164 | 268 | 242 | 26 | 123,324.25 | 9.70% |
| Urban Kitchen 102 | 268 | 257 | 11 | 122,406.71 | 4.10% |
| Food Hub 243 | 268 | 246 | 22 | 122,051.26 | 8.21% |
| Urban Bites 143 | 266 | 245 | 21 | 123,854.04 | 7.89% |

**Business Insights**

- Urban House 150 and Street Hub 065 jointly recorded the highest order volume, with 282 orders each.
- Urban House 150 had a higher delivered-order value than Street Hub 065.
- Street Bites 164 had the highest cancellation rate among the top 10 restaurants at 9.70%.
- Urban Kitchen 102 had the lowest cancellation rate among the top 10 at 4.10%.
- High order volume does not automatically mean higher delivered-order value or a lower cancellation rate.

**Business Relevance**

Comparing order volume, delivered-order value, and cancellation rate provides a more balanced view of restaurant performance. Restaurants with higher cancellation rates may warrant further investigation.

**Limitations**

- The results cover only the top 10 restaurants ranked by total order volume.
- Delivered-order value is the sum of `Final_Amount` for delivered orders; it is not profit or confirmed accounting revenue.
- The analysis describes performance patterns and does not establish the causes of cancellations.



### 19. Customer and Order Behaviour Analysis

**Objective**

Analyse customer ordering behaviour and identify customers who contribute the most to delivered-order value.

**Business Questions**

- How many orders has each customer placed?
- How many of each customer's orders were delivered?
- What is the delivered-order value for each customer?
- Which customers place orders most frequently?
- Which customers contribute the highest delivered-order value?

**Approach**

Join the `customers` and `orders` tables using `Customer_ID`. Aggregate order metrics at the customer level, count total orders and delivered orders separately, and calculate delivered-order value using `Final_Amount` for delivered orders only.

**Business Relevance**

Understanding customer ordering frequency and delivered-order value can help identify frequent customers and high-value customers. These insights may support customer segmentation, retention strategies, and targeted marketing.

**Data Rules**

- Include all order statuses when calculating total orders.
- Count only delivered orders in `Delivered_Orders`.
- Include only delivered orders when calculating `Delivered_Order_Value`.

**Results and Insights**

#### 19.1 Customer-Level Order Analysis

**Objective**

Analyse individual customer ordering behaviour and compare order frequency, delivered-order value, and cancellation behaviour.

**Approach**

Joined the `customers` and `orders` tables using `Customer_ID`. Grouped the results by customer ID, name, and customer segment. Used conditional aggregation to count delivered and cancelled orders and calculate the final order amounts associated with each status. Calculated cancellation rate as cancelled orders divided by total orders, multiplied by 100. Sorted customers by total order count in descending order and returned the top 10.

**Example Finding**

The highest-ordering customer in the displayed results placed 40 orders, including 38 delivered orders and 2 cancelled orders. The customer's delivered-order value was 21,499.95, and the cancellation rate was 5.00%.

**Business Relevance**

These metrics help compare frequent customers and their contribution to delivered-order value. They can support customer segmentation and retention analysis.

**Limitations**

- The results cover only the top 10 customers by order count.
- Delivered-order value is not profit.
- The analysis describes customer ordering patterns and does not establish the reasons behind cancellations.

#### 19.2 Customer Segment Analysis

**Objective**

Compare order behaviour, delivered-order value, and cancellation rates across customer segments.

**Approach**

Joined the `customers` and `orders` tables using `Customer_ID` and grouped the results by `Customer_Segment`. Counted distinct customers and total orders separately. Used conditional aggregation to calculate delivered and cancelled order counts and their respective order values. Calculated cancellation rate as cancelled orders divided by total orders, multiplied by 100.

**Results**

| Customer Segment | Total Customers | Total Orders | Delivered Orders | Delivered-Order Value | Cancelled Orders | Cancelled-Order Value | Cancellation Rate |
|---|---:|---:|---:|---:|---:|---:|---:|
| Regular | 1,585 | 38,236 | 35,339 | 16,959,166.77 | 2,897 | 1,410,959.94 | 7.58% |
| New | 480 | 11,551 | 10,702 | 5,209,365.50 | 849 | 414,354.09 | 7.35% |
| Premium | 435 | 10,213 | 9,409 | 4,497,889.88 | 804 | 399,676.70 | 7.87% |

**Business Insights**

- Regular customers accounted for the largest customer count, total order volume, and delivered-order value.
- New customers had the lowest cancellation rate at 7.35%.
- Premium customers had the highest cancellation rate at 7.87%.
- Segment totals should be interpreted alongside the number of customers in each segment.

**Business Relevance**

This analysis helps compare ordering activity and fulfilment outcomes across customer segments. The results can guide further investigation into customer retention and segment-specific service improvements.

**Limitations**

- Aggregate delivered-order value is not profit.
- Differences in segment totals partly reflect differences in customer counts.
- The analysis identifies patterns but does not explain the causes of cancellation differences.