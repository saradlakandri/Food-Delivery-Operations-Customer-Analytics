# Food Delivery Operations & Customer Analytics
# Python Business Analysis
# Objective: Analyse customer ordering patterns and delivery performance to identify insights that can support operational planning and business decision-making.
import numpy as np
import pandas as pd
from pandas._config import display

orders = pd.read_csv('C:/Users/Renewfy/Downloads/Sharpener Final Module/Food Delivery Operations & Customer Analytics/data/cleaned/orders.csv')
print(orders.head())

# Step 1: Inspect the structure of the cleaned orders dataset
# Review column names and data types to understand the dataset before performing the analysis.

print(orders.columns.tolist())
print(orders.dtypes)

# Step 2: Inspect order date and time formats
# Review sample values to understand the existing date and time formats before converting the columns.

print(orders[['Order_Date', 'Order_Time']].head(10))

# Step 3: Convert order date and time columns to appropriate datetime types
# Convert the columns to datetime formats to enable weekday and hourly demand analysis.

orders['Order_Date'] = pd.to_datetime(orders['Order_Date'])
orders['Order_Time'] = pd.to_datetime(orders['Order_Time'], format='%H:%M:%S')

# Step 4: Analyse order volume by day of the week
# The weekday was extracted from Order_Date and used to group and count orders for each day of the week.
# The results show how order demand is distributed across weekdays.

orders['Day_of_Week'] = orders['Order_Date'].dt.day_name()

weekday_orders = (
    orders.groupby('Day_of_Week')['Order_ID']
    .count()
    .reset_index(name='Total_Orders')
    .sort_values('Total_Orders', ascending=False)
)
print(weekday_orders)

# Findings:
# Friday recorded the highest order volume with 8,747 orders.
# Sunday recorded the lowest order volume with 8,372 orders.
# The difference between the two days was 375 orders, indicating relatively consistent order demand across weekdays.


# Step 5: Analyse order volume by hour of the day
# The hour was extracted from Order_Time and used to group and count orders across the 24 hours of the day.
# The results help identify periods with relatively higher and lower order demand.


orders['Order_Hour'] = orders['Order_Time'].dt.hour
Order_by_Hours = (
    orders.groupby('Order_Hour')['Order_ID']
    .count()
    .reset_index(name='Total_Orders')
    .sort_values('Total_Orders', ascending=False)
)
print(Order_by_Hours, Order_by_Hours['Total_Orders'].sum())

# Findings:
# The busiest hour was 15:00–15:59, with 2,592 orders.
# The quietest hour was 00:00–00:59, with 2,411 orders.
# The difference between these hours was 181 orders.

# Step 6: Prepare hourly order data for visualisation
# The hourly order counts were arranged chronologically, from 00:00 to 23:00, to present the daily demand pattern in the correct time sequence.

Order_by_Hourly_wise = (
    orders.groupby('Order_Hour')['Order_ID']
    .count()
    .reset_index(name='Total_Orders')
    .sort_values('Order_Hour')
)
print(Order_by_Hourly_wise, Order_by_Hours['Total_Orders'].sum())


# Step 7: Visualise hourly order demand
# A line chart presents the number of orders recorded during each hour of the day, making changes in hourly demand easier to observe.

import matplotlib.pyplot as plt
plt.figure(figsize=(10, 5))
plt.plot(Order_by_Hourly_wise['Order_Hour'], Order_by_Hourly_wise['Total_Orders'], color='blue', marker = 'o')
plt.title('Hourly Order Demand')
plt.xlabel('Hour of the Day')
plt.ylabel('Number of Orders')
plt.grid(True)
plt.tight_layout()
plt.show()


# Step 8: Compare peak hourly demand with average demand
# NumPy was used to calculate the average and maximum hourly order volumes and the difference between these values.
# This comparison measures how far peak demand exceeds the average hourly order volume.



avg_orders = np.mean(Order_by_Hourly_wise['Total_Orders'])
max_orders = np.max(Order_by_Hourly_wise['Total_Orders'])
peak_difference = max_orders - avg_orders

print("Average Hourly Orders:", round(avg_orders, 2))
print("Maximum Hourly Orders:", max_orders)
print("Peak vs Average Difference:", round(peak_difference, 2))

# Findings:
# Average hourly order volume was 2,500 orders.
# The maximum hourly volume was 2,592 orders.
# Peak demand exceeded the average by 92 orders, representing an increase of approximately 3.68%.

# Step 9: Delivery Dataset Inspection and Preparation
# The delivery dataset was loaded and inspected to understand its structure, columns, data types, and numerical distributions.

import pandas as pd
deliveries = pd.read_csv("C:/Users/Renewfy/Downloads/Sharpener Final Module/Food Delivery Operations & Customer Analytics/data/cleaned/deliveries.csv")
print(deliveries.head())
deliveries.info()
print(deliveries.describe())

# Step 9.2: Validate the Order_ID key before merging datasets
# Duplicate records and duplicate Order_ID values were checked in both datasets to assess the suitability of the common key for merging.

duplicate_deliveries = deliveries.duplicated().sum()
print(duplicate_deliveries)

duplicate_order_id_delivery = deliveries['Order_ID'].duplicated().sum()
print('Count of Duplicate order_id under Deliveries is: ' , duplicate_order_id_delivery)

duplicate_order_id_order = orders['Order_ID'].duplicated().sum()
print('Count of Duplicate order_id unders Orders is: ' , duplicate_order_id_order)

# Findings:
# No duplicate Order_ID values were found in either dataset.
# No duplicate records were found in the Deliveries dataset.
# The Order_ID key therefore provides a one-to-one match between available order and delivery records.

# Step 9.3: Merge orders and deliveries datasets
# An inner merge was performed using Order_ID to retain orders with corresponding delivery records.
# The resulting dataset was inspected to validate the number of matched records.

ord_del_inn = pd.merge(orders, deliveries, on='Order_ID',how ='inner')
print(ord_del_inn.head())

print("Merged Dataset Shape:", ord_del_inn.shape)
print("Total Records:", len(ord_del_inn))

# Findings:
# The inner merge produced 55,450 records across 24 columns.
# These records represent orders with matching delivery information.

# Step 10: Identification of Orders Without Delivery Records
# A left merge retained all records from the Orders dataset.
# Missing Delivery_Status values were used to identify orders without corresponding delivery records.

ord_del_left = pd.merge(orders, deliveries, on='Order_ID',how ='left')

# Step 11: Analysis of Orders Without Delivery Records
# The order status of unmatched records was examined to understand why they were absent from the Deliveries dataset.


filter_ord_del_left = ord_del_left[(ord_del_left['Delivery_Status'].isna()== True)]
print(len(filter_ord_del_left))
print('The order status for Orders with no matching Delivery Status is: ', filter_ord_del_left['Order_Status'].unique().tolist())

# Findings:
# The left merge identified 4,550 orders without matching delivery records.
# All 4,550 unmatched orders had an Order_Status of 'Cancelled'.
# This explains the difference in record counts between the Orders and Deliveries datasets.

# Step 12: Delivery Distance and Time Analysis
# The relationship between delivery distance and actual delivery time was examined using correlation analysis.

dis_min_corr = ord_del_inn['Distance_KM'].corr(ord_del_inn['Actual_Delivery_Min'])
print('the correlation between Distance_KM and Actual_Delivery_Min is: ' , round(dis_min_corr,2))

import seaborn as sns
plt.figure(figsize=(10, 5))
sns.scatterplot(data = ord_del_inn , x = ord_del_inn['Distance_KM'] , y = ord_del_inn['Actual_Delivery_Min'])
plt.show()

# Findings:
# The correlation coefficient was 0.07, indicating a very weak positive linear relationship between distance and actual delivery time.
# Delivery distance alone does not strongly explain variations in actual delivery duration.



# Step 13: Investigation of Unusually Short Delivery Times
# Delivery records with actual durations of 5 minutes or less were examined against their estimated delivery times and distances to identify potential data-quality anomalies.

deliveries_2min = ord_del_inn[ord_del_inn['Actual_Delivery_Min'] <= 5]
print(deliveries_2min[['Order_ID' , 'Distance_KM' , 'Estimated_Delivery_Min' , 'Actual_Delivery_Min' , 'Delivery_Status']])

print(deliveries_2min[['Distance_KM' , 'Estimated_Delivery_Min' , 'Actual_Delivery_Min']])

# Findings:
# 25 delivery records had an actual delivery time of 2 minutes.
# Their estimated delivery times ranged from 25 to 60 minutes.
# These records were flagged as potential data-quality anomalies.
# The original dataset was retained without modification.


# Step 14: Weekday Order Demand Visualisation
# The bar chart presents the distribution of 60,000 orders across the seven days of the week, making differences in daily order demand easier to compare and interpret.




day_to_num = {
    'Monday': 0, 'Tuesday': 1, 'Wednesday': 2,
    'Thursday': 3, 'Friday': 4, 'Saturday': 5, 'Sunday': 6
}
weekday_orders['Day_Number'] = weekday_orders['Day_of_Week'].map(day_to_num)
weekday_orders = weekday_orders.sort_values(by='Day_Number')

plt.figure(figsize=(10, 5))
plt.bar(weekday_orders['Day_of_Week'], weekday_orders['Total_Orders'])
plt.title('Daily Order Demand')
plt.xlabel('Weekday')
plt.ylabel('No. of Orders')
plt.tight_layout()
plt.show()

# Findings:
# Friday recorded the highest order volume with 8,747 orders, while Sunday recorded the lowest with 8,372 orders.
# The difference between the highest and lowest daily volumes was 375 orders.
# Overall, order demand remained relatively consistent across all seven days, without substantial variation in volume.

# Step 15: Customer Ordering Behaviour Analysis
# Customer-level ordering frequency is examined to understand how frequently customers place orders and how ordering activity is distributed across the customer base.
#
# The analysis focuses on identifying one-time and repeat customers and examining ordering frequency across the customer base.


# Step 15.1: Inspect Customer Dataset Structure
# The customer dataset was loaded and examined to understand
# its structure, column names, data types, and numerical
# distributions before performing customer-level analysis.

customers = pd.read_csv("C:/Users/Renewfy/Downloads/Sharpener Final Module/Food Delivery Operations & Customer Analytics/data/cleaned/customers.csv")
print(customers.head())
customers.info()
print(customers.describe())
print(customers.columns.tolist())
print(customers.dtypes)

# Step 15.2: Prepare Customer Signup Date
# The Signup_Date column was converted to datetime format to ensure that customer registration dates are stored  in an appropriate date type for analysis.

customers['Signup_Date'] = pd.to_datetime(customers['Signup_Date'])
print(customers['Signup_Date'].dtype)

# Step 15.3: Customer-Level Order Frequency Analysis
# Customer and order records are combined using Customer_ID to examine individual customer ordering frequency.
# The analysis focuses on the number of orders placed by each customer across the dataset.

ord_cust_inn = pd.merge(orders, customers, on='Customer_ID',how ='inner')
print(ord_cust_inn.head())
cus_total_order = (ord_cust_inn.groupby(['Customer_ID', 'Customer_Name', 'Customer_Segment']).agg(Total_Orders=("Order_ID", 'count')).reset_index())
print(cus_total_order)

# Findings:
# The customer-level summary contains 2,500 customers.
# Order frequency was calculated individually for each customer.
# The resulting dataset contains customer ID, customer name, customer segment, and total order count.


# Step 15.4: One-Time and Repeat Customer Analysis
# Customers are classified based on their total order frequency to distinguish between one-time and repeat customers.
# The analysis examines the number and percentage of customers in each group to understand repeat ordering behaviour.



cus_total_order['Customer_Type'] = np.where(cus_total_order['Total_Orders'] == 1, 'One-time', 'Repeat')
print(cus_total_order)
total_cust_type = cus_total_order.groupby('Customer_Type')['Customer_ID'].count().reset_index()
print(total_cust_type)

# Findings:
# All 2,500 customers were classified as repeat customers.
# No one-time customers were identified in the dataset.
# Repeat customers account for 100% of the customer base.

# Step 15.5: Customer Type Percentage Analysis
# The percentage distribution of one-time and repeat customers was calculated to understand the composition of the customer base.

# Calculated the percentage distribution of one-time and repeat customers across the customer base.
customer_percentage = cus_total_order['Customer_Type'].value_counts(normalize=True) * 100
print(customer_percentage)

# Findings:
# Repeat customers account for 100% of the customer base, representing all 2,500 customers.
# No one-time customers were identified in the dataset.

# Step 15.6: Customer Order Frequency Distribution
# Customer ordering frequency was examined using descriptive statistics to understand the distribution of orders across the customer base.
# The analysis focuses on the minimum, maximum, average, and median number of orders placed per customer.

print(cus_total_order['Total_Orders'].describe())

# Findings:
# The average and median order frequency were both 24 orders per customer.
# Individual customer order counts ranged from 10 to 40 orders.
# The middle 50% of customers placed between 21 and 27 orders.
# The standard deviation of 4.76 indicates some variation in ordering frequency across customers.


# Overall Findings:
# The analysis covered all 2,500 customers in the dataset.
# All customers were classified as repeat customers, with no one-time customers identified.
# The average and median order frequency were both 24 orders per customer.
# Customer order frequency ranged from 10 to 40 orders.
# The middle 50% of customers placed between 21 and 27 orders.