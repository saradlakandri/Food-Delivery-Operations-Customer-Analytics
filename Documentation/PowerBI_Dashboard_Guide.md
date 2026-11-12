# Power BI Dashboard Guide
## Food Delivery Operations & Customer Analytics

## Overview

The Power BI report presents an interactive view of food delivery business performance across four analytical areas: overall business performance, restaurant performance, delivery operations and customer insights.

The report uses data from the project datasets and provides KPI cards, trend analysis, comparative charts and interactive slicers.

The four pages are designed to help users move from an overall business view to more focused operational and customer-level analysis.

---

## 1. Executive Overview

**Business objective:** Provide an overall view of order performance, delivered-order value, cancellations and customer segment contribution.

### Key Performance Indicators

- Total Orders
- Delivered Orders
- Cancelled Orders
- Delivered Revenue
- Cancellation Rate

### Visuals and Analysis

| Visual | Business Question |
|---|---|
| Monthly Order Trend | How does order volume change over time? |
| Top 10 Restaurants by Delivered Orders | Which restaurants contribute the highest delivered order volume? |
| Top 10 Restaurants by Highest Cancellation Rate | Which restaurants have relatively high cancellation rates? |
| Delivery Status Distribution | What proportion of orders are delivered or cancelled? |
| Average Delivery Time by Status | How does delivery duration differ between delayed and on-time deliveries? |
| Orders by Customer Segment | How are orders distributed across customer segments? |
| Delivered Revenue by Customer Segment | Which customer segments contribute the most delivered-order value? |

### Interactive Filters

Year, Quarter, Month, City, Customer Segment and Payment Method.

### Key Business Findings

- 92.42% of orders were delivered.
- 7.58% of orders were cancelled.
- Delivered-order value was approximately ₹26.67 million across the complete dataset.
- Regular customers contributed the largest order volume and delivered-order value among the customer segments.

---

## 2. Restaurant Performance

**Business objective:** Compare restaurant performance using delivered order volume, delivered-order value, cancellation rates and restaurant ratings.

### Key Performance Indicators

- Total Restaurants
- Delivered Orders
- Delivered Revenue
- Average Restaurant Rating

### Visuals and Analysis

| Visual | Business Question |
|---|---|
| Top 5 Restaurants by Delivered Orders | Which restaurants have the highest delivered order volume? |
| Top 5 Restaurants by Delivered Revenue | Which restaurants generate the highest delivered-order value? |
| Top 5 Restaurants by Lowest Cancellation Rate | Which restaurants have the lowest cancellation rates? |
| Top 5 Restaurants by Average Rating | Which restaurants have the highest ratings? |
| Bottom 5 Restaurants by Delivered Orders | Which restaurants have the lowest delivered order volume? |
| Bottom 5 Restaurants by Delivered Revenue | Which restaurants have the lowest delivered-order value? |
| Bottom 5 Restaurants by Highest Cancellation Rate | Which restaurants have the highest cancellation rates? |
| Bottom 5 Restaurants by Average Rating | Which restaurants have the lowest ratings? |

### Interactive Filters

Year, Quarter, Month, City, Cuisine Name and Restaurant Name.

### Business Interpretation

The page provides a comparative view of restaurant performance. It helps distinguish restaurants with stronger delivered order volumes and delivered-order values from those with higher cancellation rates or lower customer ratings.

---

## 3. Delivery Operations

**Business objective:** Evaluate delivery performance, understand delivery delays and examine how delivery characteristics relate to operational outcomes.

### Key Performance Indicators

- Total Deliveries
- On-Time Deliveries
- Delayed Deliveries
- Average Delivery Time
- Average Delay

### Visuals and Analysis

| Visual | Business Question |
|---|---|
| Delivery Status Distribution | What proportion of deliveries are delayed or on time? |
| Average Delivery Time by Status | How does actual delivery duration differ by delivery status? |
| Delivery Distance vs Actual Delivery Time | Is there a relationship between delivery distance and actual delivery duration? |
| Delivery Status by Vehicle Type | How is delivery status distributed across vehicle types? |

### Interactive Filters

Year, Quarter, Month, City, Delivery Status, Delivery Partner and Vehicle Type.

### Key Business Findings

- 55,450 deliveries were recorded.
- 48,153 deliveries were classified as delayed and 7,297 as on time in the complete dataset.
- Average actual delivery time was approximately 58.05 minutes.
- Average delay among deliveries that exceeded their estimated duration was approximately 18.44 minutes.
- The distance-versus-time scatter plot shows considerable variation in delivery duration at different distances.

### Scatter Plot Interpretation

The separate Python analysis calculated a correlation coefficient of 0.07 between delivery distance and actual delivery duration.

This indicates a very weak positive linear relationship. Delivery distance alone does not strongly explain variations in actual delivery time.

---

## 4. Customer Insights

**Business objective:** Understand customer composition, repeat ordering behaviour, order frequency and customer acquisition trends.

### Key Performance Indicators

- Total Customers
- Repeat Customers
- Repeat Customer Rate
- Average Orders per Active Customer
- New Customers

### Visuals and Analysis

| Visual | Business Question |
|---|---|
| New Customers by Segment | How are newly acquired customers distributed across customer segments? |
| Orders by Customer Segment | Which customer segments contribute the highest order volume? |
| Average Orders per Customer by Segment | How frequently do customers in each segment place orders? |
| Delivered Revenue by Customer Segment | Which customer segments contribute the most delivered-order value? |
| Monthly Customer Acquisition Trend | How does customer acquisition change over time? |

### Interactive Filters

Year, Quarter, Month, City, Customer Segment and Gender.

### Business Interpretation

The page examines customer composition and ordering frequency across customer segments. It also tracks customer acquisition over time and compares the contribution of different segments.

Repeat customers are defined as customers who have placed more than one order.

**Important:** Customer KPIs and charts respond to the selected report filters. Their displayed values can therefore change when the year, month, city or other slicers are changed.

---

## Dashboard Design and Data Model

### Design Approach

- Four separate pages for focused business analysis.
- Consistent page headers and visual styling.
- KPI cards for important business metrics.
- Interactive slicers for filtering and exploration.
- Bar, column, donut, line and scatter charts selected according to the analytical purpose.

### Data Model

The Power BI model uses relationships between the core business tables:

- Customers and Orders
- Restaurants and Orders
- Orders and Deliveries
- Delivery Partners and Deliveries
- Orders and Reviews

A separate Calendar table supports time-based analysis. The Data Dictionary table is retained as a reference table.

### DAX

DAX measures and calculated columns support KPI calculations, customer analysis, time-based reporting and visual aggregation.

Examples include order counts, delivered-order value, cancellation rate, repeat customer rate and average order frequency.

---

## Conclusion

The Power BI report brings together the major findings from the SQL and Python analysis into an interactive business reporting experience.

It provides a structured view of business performance and allows users to explore order trends, restaurant performance, delivery efficiency and customer behaviour through a common report.