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
    CASE
        WHEN Distance_KM <= 2 THEN 'Short'
        WHEN Distance_KM <= 5 THEN 'Medium'
        WHEN Distance_KM <= 8 THEN 'Long'
        ELSE 'Very Long'
    END AS Distance_Band,
    COUNT(Actual_Delivery_Min) AS Deliveries,
    ROUND(AVG(Estimated_Delivery_Min), 0) AS Avg_Estimated_time,
    ROUND(AVG(Actual_Delivery_Min), 0) AS Avg_Actual_time
FROM
    deliveries
GROUP BY Distance_Band
ORDER BY Distance_Band;

-- Task 5.5: Delivery Performance by Distance
-- Approach: Grouped deliveries into distance bands using CASE. Calculated delivery count, average estimated time, and average actual time.
-- Result: Average estimated delivery time ranged from 42 to 43 minutes, while average actual delivery time ranged from 57 to 60 minutes.
-- Business Insight: Actual delivery time exceeded estimated time across all distance bands. Very Long deliveries had the largest average gap, at approximately 17 minutes.
-- Business Relevance: Review delivery estimates and investigate other operational factors that may contribute to delays.

-- _______________________________________________________________________________________________________________________________________________________
-- Task 6: Customer Satisfaction Analysis
-- Objective: Analyse customer ratings and understand satisfaction patterns.
-- Business Question: What ratings are customers giving to the service?
-- Business Relevance: Identify customer satisfaction patterns and potential areas for service improvement.

SELECT 
    *
FROM
    reviews;

SELECT 
    ROUND(AVG(Rating), 2) AS Avg_Rating
FROM
    reviews;

-- Task 6.1: Average Customer Rating
-- Objective: Calculate the average rating across all customer reviews.
-- Approach: Use AVG() on the Rating column in the reviews table.
-- Result: Average customer rating is approximately 3.86 out of 5.
-- Business Insight: Establishes an overall customer-rating baseline.
-- Limitation: The average alone does not show how ratings are distributed.


-- Task 6.2: Customer Rating Distribution
-- Objective: Analyse the frequency of each customer rating.
-- Business Question: How are reviews distributed across ratings from 1 to 5?
-- Business Relevance: Identify the proportion of low, middle, and high ratings
-- to better understand customer satisfaction patterns.

SELECT 
    rating AS Rating, COUNT(Review_ID) AS No_Reviews
FROM
    reviews
GROUP BY rating
ORDER BY No_Reviews;
    
    
    -- Task 6.2: Customer Rating Distribution
-- Approach: Counted reviews for each recorded rating and sorted by rating.
-- Result: Rating 4 was the most frequent (14,258 reviews), followed by rating 5 (10,496 reviews).
-- Data Quality Finding: 12 reviews have rating 0 and 8 reviews have rating 6.
-- Business Insight: High ratings are common, but unexpected rating values must be investigated before final satisfaction reporting.


-- Task 6.3: Rating Data Quality Check
-- Objective: Investigate reviews with ratings outside the expected 1–5 scale.
-- Business Question: Which review records contain unexpected rating values?
-- Business Relevance: Identify records that may need correction or exclusion
-- before reporting customer satisfaction.

SELECT 
    Rating, count(Rating)
FROM
    reviews
WHERE
    Rating > 5 OR Rating < 1
    group by Rating;
    
-- Task 6.3: Rating Data Quality Check
-- Approach: Counted reviews with ratings below 1 or above 5.
-- Result: 12 reviews have rating 0, and 8 reviews have rating 6.
-- Total: 20 out of 34,379 reviews (approximately 0.06%).
-- Data Quality Finding: These ratings fall outside the expected 1–5 scale. 
-- Next Step: Investigate the records before deciding whether to correct or exclude them from customer satisfaction reporting.

-- Task 6.4: Customer Satisfaction by Rating Category
-- Objective: Analyse average customer ratings across different review categories.
-- Business Question: Which aspects of the service receive higher or lower ratings?
-- Business Relevance: Identify service areas that may need improvement.
-- Approach: Calculate the average rating for each Review_Category. Data Quality Rule: Include only ratings between 1 and 5.
-- Note: Keep the original rating data unchanged.

Select *
from reviews;


SELECT 
    Review_Category, ROUND(AVG(Rating), 2) AS Avg_Rating
FROM
    reviews
WHERE
    Rating > 0 AND Rating < 6
GROUP BY Review_Category
ORDER BY Avg_Rating;

-- Task 6.4: Customer Satisfaction by Rating Category
-- Approach: Calculated average ratings for each Review_Category.
-- Data Quality Rule: Included only ratings between 1 and 5.
-- Results: Delivery and Overall averaged 3.87; Food Quality and Packaging averaged 3.86.
-- Business Insight: Average ratings are similar across all four categories.
-- Business Relevance: Further analysis of low ratings may help identify specific service issues that need attention.


-- Task 6.5: Low-Rating Analysis
-- Objective: Identify review categories with higher numbers of low ratings.
-- Business Question: How many reviews are rated 1 or 2 in each category?
-- Business Relevance: Identify service areas that may require improvement.
-- Data Quality Rule: Include only ratings between 1 and 5.

SELECT 
    Review_Category, COUNT(rating) AS No_of_Reviews
FROM
    Reviews
WHERE
    Rating > 0 AND Rating < 3
GROUP BY Review_Category
ORDER BY No_of_Reviews DESC;


-- Task 6.5: Low-Rating Analysis
-- Approach: Counted reviews rated 1 or 2 for each Review_Category.
-- Data Quality Rule: Included only ratings between 1 and 5.
-- Result: Food Quality had 1,473 low-rated reviews, followed by Overall with 1,051, Delivery with 1,015, and Packaging with 623.
-- Business Insight: Food Quality had the highest number of low-rated reviews.
-- Limitation: Counts alone do not account for differences in total review volume.
-- Next Step: Compare low-rating percentages across categories.

-- Task 6.6: Low-Rating Percentage by Category
-- Objective: Compare the proportion of low ratings across review categories.
-- Business Question: Which service category has the highest percentage of reviews rated 1 or 2?
-- Business Relevance: Compare categories fairly despite differences in review volume and identify potential service improvement priorities.
-- Data Quality Rule: Include only ratings between 1 and 5.

SELECT 
    Review_Category,
    COUNT(rating) AS Total_Valid_Reviews,
    SUM(CASE
        WHEN Rating IN (1 , 2) THEN 1
        ELSE 0
    END) AS Low_Rating_Count_1_2,
    round((SUM(CASE
        WHEN Rating IN (1 , 2) THEN 1
        ELSE 0
    END)/COUNT(rating))*100,2) as Low_Rating_Percentage
FROM
    Reviews
WHERE
    Rating > 0 AND Rating < 6
GROUP BY Review_Category
ORDER BY Total_Valid_Reviews DESC;

-- Task 6.6: Low-Rating Percentage by Category
-- Approach: Used conditional aggregation to count ratings of 1 or 2, then divided by the total valid reviews in each category.
-- Result: Food Quality had the highest low-rating percentage at 12.31%, followed by Overall at 12.14%, Packaging at 11.99%, and Delivery at 11.88%.
-- Business Insight: Food Quality has the highest proportion of low ratings, although the differences between categories are small.
-- Business Relevance: Use these percentages to help prioritise further investigation into potential service-quality issues.

-- Task 6.7: High-Rating Analysis
-- Objective: Measure the proportion of high ratings across review categories.
-- Business Question: Which categories receive the highest percentage of ratings 4 or 5?
-- Business Relevance: Identify service areas where customer feedback is strongest.
-- Data Quality Rule: Include only ratings between 1 and 5.

SELECT 
    Review_Category,
    COUNT(rating) AS Total_Valid_Reviews,
    SUM(CASE
        WHEN rating IN (4 , 5) THEN 1
        ELSE 0
    END) AS High_rating_counts_4_5,
    ROUND((SUM(CASE
                WHEN rating IN (4 , 5) THEN 1
                ELSE 0
            END)) / (COUNT(rating)) * 100,
            2) AS High_Rating_Percentage
FROM
    reviews
WHERE
    rating > 0 AND rating < 6
GROUP BY Review_Category
ORDER BY Total_Valid_Reviews DESC;
    
 -- Task 6.7: High-Rating Analysis
-- Approach: Used conditional aggregation to count reviews rated 4 or 5 and calculated the percentage within each review category.
-- Data Quality Rule: Included only ratings between 1 and 5.
-- Result: Overall had the highest high-rating percentage at 72.42%,followed by Packaging at 72.20%, Food Quality at 71.85%, and Delivery at 71.85%.
-- Business Insight: Approximately 72.05% of all valid reviews received a rating of 4 or 5 
-- Business Relevance: Identify service areas with stronger customer feedback and compare them with low-rating results.   

-- Task 6.8: Comparison of High and Low Ratings
-- Objective: Compare high and low customer ratings across review categories.
-- Business Question: Which categories have a stronger proportion of high ratings compared with low ratings?
-- Business Relevance: Identify service areas with stronger customer feedback and areas that may need improvement.
-- Data Quality Rule: Include only ratings between 1 and 5.
-- Approach: Calculate the count and percentage of high ratings (4–5) and low ratings (1–2) for each Review_Category.
-- Expected Output: Review category, total valid reviews, high-rating count, high-rating percentage, low-rating count, and low-rating percentage.

SELECT 
    Review_Category,
    COUNT(rating) AS Total_Valid_Reviews,
    SUM(CASE
        WHEN Rating IN (1 , 2) THEN 1
        ELSE 0
    END) AS Low_Rating_Count,
    SUM(CASE
        WHEN Rating IN (4 , 5) THEN 1
        ELSE 0
    END) AS High_Rating_Count,
    ROUND((SUM(CASE
                WHEN Rating IN (1 , 2) THEN 1
                ELSE 0
            END) / COUNT(rating)) * 100,
            2) AS Low_Rating,
    ROUND((SUM(CASE
                WHEN rating IN (4 , 5) THEN 1
                ELSE 0
            END) / COUNT(rating)) * 100,
            2) AS High_Rating
FROM
    Reviews
WHERE
    Rating > 0 AND Rating < 6
GROUP BY Review_Category
ORDER BY Total_Valid_Reviews DESC;
