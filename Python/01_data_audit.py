import pandas as pd

orders = pd.read_csv('C:/Users/Renewfy/Downloads/Sharpener Final Module/Food Delivery Operations & Customer Analytics/data/raw/orders.csv')
print(orders.head())

print(orders.info())
print(orders.describe())

print(orders[orders['Discount'].isna()])
print(orders[['Food_Amount','Delivery_Fee','Discount','Final_Amount']])

orders['Calculated_Discount'] = (orders['Food_Amount'] + orders['Delivery_Fee']) - orders['Final_Amount']
print(orders[orders['Discount'].isna()][['Discount' , 'Calculated_Discount', ]])
