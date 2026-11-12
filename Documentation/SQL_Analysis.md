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

Database loading is complete. The next stage is to validate relationships between tables and analyse business questions using SQL.

### 6. Business Analysis Areas

- Order trends and status distribution
- Revenue and order value
- Order cancellations
- Delivery performance
- Restaurant performance
- Customer behaviour and reviews

### 7. Findings and Recommendations

*To be completed as SQL analysis progresses.*

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

**Objective:** Analyse monthly order volume over time.

**Business Question:** How does the number of orders change from month to month?

**Approach:** Used `DATE_FORMAT()` to convert order dates into a year-month format, counted orders for each month, and sorted the results chronologically.

**Initial Observation:** Monthly order volumes vary over time. January 2022 recorded 1,254 orders, while December 2025 recorded 1,261 orders among the results reviewed.

**Business Relevance:** Monthly order trends can help identify changes in demand and support staffing, delivery capacity, and operational planning.