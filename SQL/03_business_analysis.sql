-- Task 1: Order Volume and Status Analysis
-- Objective: Calculate the total number of orders and understand their status distribution.
-- Business Questions:
-- 1. How many orders were placed in total?
-- 2. How many orders were delivered?
-- 3. How many orders were cancelled?
-- Approach: Use aggregate functions and conditional filtering to analyse order statuses.
-- Business Relevance: Understand overall order volume and cancellation performance.



-- 1. How many orders were placed in total?
SELECT 
    COUNT(Order_ID)
FROM
    orders;

-- 2. How many orders were delivered?
SELECT 
    COUNT(Order_ID)
FROM
    orders
WHERE
    Order_Status = 'delivered';
    
    
-- How many orders were cancelled?
SELECT 
    COUNT(Order_ID)
FROM
    orders
WHERE
    Order_Status = 'cancelled';

-- Observation: 60,000 total orders; 55,450 delivered and 4,550 cancelled.
-- Delivered rate: 92.42%; cancellation rate: 7.58%.

-- ________________________________________________________________________________________________________________________________

-- Task 2: Revenue Analysis
-- Objective: Calculate the total revenue generated from orders.
-- Business Question: What is the total final order amount?
-- Approach: Use SUM() on the Final_Amount column.
-- Business Relevance: Establish a baseline for analysing business revenue.
-- Note: Confirm whether cancelled orders should be excluded from revenue reporting.

SELECT 
    SUM(Final_Amount) AS Total_Final_Order_Amount
FROM
    orders;
    
-- Observation: The total Final_Amount across all orders is 28,891,412.88.
-- Note: This includes cancelled orders and should not yet be treated as realised revenue.

SELECT 
    SUM(Final_Amount) AS Total_Delivered_Final_Order_Amount
FROM
    orders
WHERE
    Order_Status = 'delivered';
    
    
    
   SELECT 
    SUM(Final_Amount) AS Total_Cancelled_Final_Order_Amount
FROM
    orders
WHERE
    Order_Status = 'cancelled'; 
    
 -- Observation: Total Final_Amount across all orders is 28,891,412.88.
-- Delivered orders account for 26,666,422.15.
-- Cancelled orders account for 2,224,990.73.
-- Business Note: Treat the delivered-order amount as the initial completed-sales measure.
-- Confirm the currency and the definition of Final_Amount before reporting recognised revenue.

-- ________________________________________________________________________________________________________________________________

-- Task 3: Average Order Value (AOV)
-- Objective: Calculate the average final amount per order.
-- Business Question: What is the average amount spent per order?
-- Business Relevance: Understand typical order value and establish a baseline for pricing, promotions, and customer spending analysis.

SELECT 
    avg(Final_Amount) AS Average_Final_Order_Amount
FROM
    orders;

SELECT 
    avg(Final_Amount) AS Average_Delivered_Final_Order_Amount
FROM
    orders
WHERE
	Order_Status = 'Delivered';
    
SELECT 
    avg(Final_Amount) AS Average_Delivered_Final_Order_Amount
FROM
    orders
WHERE
	Order_Status = 'Cancelled';

-- Observation: Average Final_Amount across all orders is approximately ₹481.52.
-- Delivered orders average approximately ₹480.91.
-- Cancelled orders average approximately ₹489.01.
-- Further analysis is required to determine whether order value is related to cancellation.

-- ________________________________________________________________________________________________________________________________

-- Task 4: Monthly Order Trends
-- Objective: Analyse monthly order volume over time.
-- Business Question: How does the number of orders change from month to month?
-- Business Relevance: Identify demand patterns and periods of higher or lower order activity to support operational planning.

SELECT 
    DATE_FORMAT(Order_date, '%Y-%m') AS YearMonth,
    COUNT(Order_ID) AS Order_Volume
FROM
    orders
GROUP BY YearMonth
ORDER BY YearMonth ASC;


-- Observation: Monthly order volume varies over time, with noticeable changes between consecutive months. Further analysis is required to identify seasonality.

-- ________________________________________________________________________________________________________________________________


-- Task 5: Delivery Time Analysis
-- Objective: Analyse the time taken to complete deliveries.
-- Business Question: What is the average delivery time, and how does it vary?
-- Business Relevance: Assess delivery efficiency and identify opportunities to improve delivery performance and customer experience.


-- checking the columns of deliveries table
SELECT 
    *
FROM
    deliveries
LIMIT 1;

-- avg time taken calculation for the delivery
SELECT 
    avg(Actual_Delivery_Min) AS Average_Delivery_Time
FROM
    orders o
        LEFT JOIN
    deliveries d ON o.Order_ID = d.Order_ID
WHERE
    Order_Status = 'delivered';

-- 

-- Task 5.2: On-Time Delivery Performance
-- Objective: Evaluate delivery performance against estimated delivery times.
-- Business Question: How many deliveries are on time versus delayed?
-- Business Relevance: Measure delivery reliability and identify opportunities to improve delivery estimates and customer experience.

SELECT 
    Delivery_Status, COUNT(Delivery_Status) AS Count
FROM
    deliveries
GROUP BY Delivery_Status;

-- Task 5.2: On-Time Delivery Performance
-- Approach: Count delivery records by Delivery_Status.
-- Result: 7,297 deliveries were On Time and 48,153 were Delayed.
-- Business Insight: 86.84% of delivery records were marked as Delayed.
-- Further Analysis: Investigate the difference between estimated and actual delivery times to understand the extent of delays.

-- Task 5.3: Delivery Status Consistency Check
-- Objective: Validate the original delivery status against estimated and actual times.
-- Business Question: Does the recorded Delivery_Status match the time-based classification?
-- Business Relevance: Establish reliable delivery status classifications before measuring delivery performance.

SELECT 
    Delivery_Status as Correct_delivery_Status, count(Delivery_Status) AS count
FROM
    deliveries
WHERE
    Actual_Delivery_Min <= Estimated_Delivery_Min
GROUP BY Delivery_Status
HAVING Delivery_Status = 'On Time';


SELECT 
    Delivery_Status as Incorrect_delivery_Status, COUNT(Delivery_Status) AS count
FROM
    deliveries
WHERE
    Actual_Delivery_Min <= Estimated_Delivery_Min
GROUP BY Delivery_Status
HAVING Delivery_Status = 'Delayed';

SELECT 
    Delivery_Status as Incorrect_delivery_Status, count(Delivery_Status) AS count
FROM
    deliveries
WHERE
    Actual_Delivery_Min > Estimated_Delivery_Min
GROUP BY Delivery_Status
HAVING Delivery_Status = 'On Time';

SELECT 
    Delivery_Status as Correct_delivery_Status, count(Delivery_Status) AS count
FROM
    deliveries
WHERE
    Actual_Delivery_Min > Estimated_Delivery_Min
GROUP BY Delivery_Status
HAVING Delivery_Status = 'Delayed';

-- Task 5.3: Delivery Status Consistency Check
-- Approach: Compared the original status with a classification based on estimated and actual delivery times.
-- Result: 21 records were labelled Delayed despite actual time being less than or equal to estimated time. 
-- No On Time records exceeded the estimated delivery time.
-- Business Insight: The original status matches the time-based rule for approximately 99.96% of delivery records.
-- Note: This check validates consistency, not the accuracy of recorded times.

-- Task 5.4: Average Delay Duration
-- Objective: Measure the average delay among deliveries that exceeded their estimated delivery time.
-- Business Question: On average, how many minutes late are delayed deliveries?
-- Approach: Calculate the difference between actual and estimated delivery times, including only records where actual time exceeds estimated time.
-- Business Relevance: Quantify delivery delays and identify opportunities to improve delivery efficiency.

SELECT 
    AVG(Actual_Delivery_Min - Estimated_Delivery_Min) AS Average_Delay_Duration
FROM
    deliveries
WHERE
    Actual_Delivery_Min > Estimated_Delivery_Min;

-- Task 5.4: Average Delay Duration
-- Approach: Calculate actual delivery time minus estimated delivery time.
-- Filter: Include only deliveries where actual time exceeds estimated time.
-- Result: Average delay duration is approximately 18.44 minutes.
-- Business Insight: Deliveries that exceeded their estimates were late by an average of approximately 18.44 minutes.
-- Business Relevance: Quantify delays to identify opportunities to improve delivery estimates and operational efficiency.

-- Task 5.5: Delivery Performance by Distance
-- Objective: Analyse the relationship between delivery distance and duration.
-- Business Question: How does average delivery time vary by distance?
-- Business Relevance: Understand distance-related delivery patterns to support delivery planning and operational efficiency.

SELECT 
    -- Distance_KM,
    
    case
		when Distance_KM <= 2 then 'Short'
        when Distance_KM <= 5 then 'Medium'
        when Distance_KM <= 8 then 'Long'
        Else 'Very Long' 
	END as Distance_Band,
    count(Actual_Delivery_Min) as Deliveries,
    round(avg(Estimated_Delivery_Min),0) as Avg_Estimated_time,
    round(avg(Actual_Delivery_Min),0) as Avg_Actual_time
FROM
    deliveries
Group By Distance_Band
order by Distance_Band

-- Task 5.5: Delivery Performance by Distance
-- Approach: Grouped deliveries into distance bands using CASE. Calculated delivery count, average estimated time, and average actual time.
-- Result: Average estimated delivery time ranged from 42 to 43 minutes, while average actual delivery time ranged from 57 to 60 minutes.
-- Business Insight: Actual delivery time exceeded estimated time across all distance bands. Very Long deliveries had the largest average gap, at approximately 17 minutes.
-- Business Relevance: Review delivery estimates and investigate other operational factors that may contribute to delays.
