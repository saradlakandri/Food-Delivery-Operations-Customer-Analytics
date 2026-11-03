# Food Delivery Operations & Customer Analytics
# Python Business Analysis
# Objective: Analyse order timing patterns to identify potential
# peak periods for restaurant preparation and delivery staffing.
import numpy as np
import pandas as pd
from pandas._config import display

orders = pd.read_csv('C:/Users/Renewfy/Downloads/Sharpener Final Module/Food Delivery Operations & Customer Analytics/data/cleaned/orders.csv')
print(orders.head())

# Step 1: Inspect the structure of the cleaned orders dataset
# Review column names and data types before performing analysis.

print(orders.columns.tolist())
print(orders.dtypes)

# Step 2: Inspect order date and time formats
# Check sample values before converting date and time columns.

print(orders[['Order_Date', 'Order_Time']].head(10))

# Step 3: Convert order date and time columns to appropriate datetime types
# This allows us to extract weekdays and hours for order demand analysis.

orders['Order_Date'] = pd.to_datetime(orders['Order_Date'])
orders['Order_Time'] = pd.to_datetime(orders['Order_Time'], format='%H:%M:%S')

# Step 4: Analyse order volume by day of the week
# Extract weekday information from Order_Date to identify busy and quiet days.
# Count orders for each weekday to understand demand patterns.

orders['Day_of_Week'] = orders['Order_Date'].dt.day_name()

weekday_orders = (
    orders.groupby('Day_of_Week')['Order_ID']
    .count()
    .reset_index(name='Total_Orders')
    .sort_values('Total_Orders', ascending=False)
)
print(weekday_orders)


# Step 5: Analyse order volume by hour of the day
# Extract the hour from Order_Time to understand when customers place orders.
# Count orders for each hour to identify peak and off-peak periods.
# Use the results to explore potential staffing and delivery capacity needs.


orders['Order_Hour'] = orders['Order_Time'].dt.hour
Order_by_Hours = (
    orders.groupby('Order_Hour')['Order_ID']
    .count()
    .reset_index(name='Total_Orders')
    .sort_values('Total_Orders', ascending=False)
)
print(Order_by_Hours, Order_by_Hours['Total_Orders'].sum())

# Step 6: Prepare hourly order data for visualisation
# Sort hours in chronological order from 00:00 to 23:00.
# This makes it easier to observe changes in order demand throughout the day.

Order_by_Hourly_wise = (
    orders.groupby('Order_Hour')['Order_ID']
    .count()
    .reset_index(name='Total_Orders')
    .sort_values('Order_Hour')
)
print(Order_by_Hourly_wise, Order_by_Hours['Total_Orders'].sum())


# Step 7: Visualise hourly order demand
# Create a line chart to show how order volume changes throughout the day.
# Highlight potential peak and off-peak periods for operational planning.

import matplotlib.pyplot as plt
plt.figure(figsize=(12,6))
plt.plot(Order_by_Hourly_wise['Order_Hour'], Order_by_Hourly_wise['Total_Orders'], color='blue', marker = 'o')
plt.xlabel('Hour')
plt.ylabel('Total Orders')
plt.title('Hourly Order Demand')
plt.xlabel('Hour of the Day')
plt.ylabel('Number of Orders')
plt.grid(True)
plt.tight_layout()
plt.show()


# Step 8: Compare peak hourly demand with average demand
# Use NumPy to calculate summary statistics for hourly order volume.
# Measure how much the busiest hour exceeds the average hourly demand.

import numpy as np

avg_orders = np.mean(Order_by_Hourly_wise['Total_Orders'])
max_orders = np.max(Order_by_Hourly_wise['Total_Orders'])
peak_difference = max_orders - avg_orders

print("Average Hourly Orders:", round(avg_orders, 2))
print("Maximum Hourly Orders:", max_orders)
print("Peak vs Average Difference:", round(peak_difference, 2))