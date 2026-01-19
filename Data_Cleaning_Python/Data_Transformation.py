import pandas as pd
import os

data_folder = r'C:\Users\alexr\Desktop\Trade Index Data\Data\Clean data'
os.chdir(data_folder)
         
# Load all three CSV files
cpi_data = pd.read_csv('CPI_Clean.csv')
retail_data = pd.read_csv('Retail_Clean.csv')
confidence_data = pd.read_csv('Consumer_Confidence_Clean.csv')

# Convert the Date columns from text to dates
cpi_data['Date'] = pd.to_datetime(cpi_data['Date'])
retail_data['Date'] = pd.to_datetime(retail_data['Date'])
confidence_data['Date'] = pd.to_datetime(confidence_data['Date'])

# Keep only the "Total" row for CPI 
cpi_total = cpi_data[cpi_data['Category'] == '00 Total'].copy()

# Keep only the "Total" row for Retail
retail_total = retail_data[retail_data['Category'] == 'Retail trade total'].copy()

# Merge datasets
merged_data = confidence_data.copy()

# Add CPI data (matching by Date)
merged_data = merged_data.merge(
    cpi_total[['Date', 'CPI']], 
    on='Date', 
    how='left'
)

# Add Retail data (matching by Date)
merged_data = merged_data.merge(
    retail_total[['Date', 'Retail_Index']], 
    on='Date', 
    how='left')

# Count how many values are missing in each column
missing_values = merged_data.isnull().sum()
print(missing_values)
print()

# If there are any missing values, fill them in
if missing_values.sum() > 0:
    # Use the last known value to fill gaps
    merged_data = merged_data.fillna(method='ffill')
    
    # If still missing at the start, use next known value
    merged_data = merged_data.fillna(method='bfill')
    
    print("Missing values filled")
else:
    print("No missing values found!")

print()

# Calculations:

# How much did CPI change from last month?
merged_data['CPI_Monthly_Change_Pct'] = merged_data['CPI'].pct_change() * 100

# How much did retail sales change from last month?
merged_data['Retail_Monthly_Change_Pct'] = merged_data['Retail_Index'].pct_change() * 100

# What would retail sales look like if we account for inflation?
merged_data['Retail_Index_Adjusted'] = (merged_data['Retail_Index'] / merged_data['CPI']) * 100

# How much did CPI change compared to 12 months ago?
merged_data['CPI_YoY_Change_Pct'] = merged_data['CPI'].pct_change(periods=12) * 100

# How much did retail sales change compared to 12 months ago?
merged_data['Retail_YoY_Change_Pct'] = merged_data['Retail_Index'].pct_change(periods=12) * 100

# How much did confidence change from last month?
merged_data['Confidence_Change'] = merged_data['Consumer_Confidence'].diff()

# Find all columns that contain numbers
numeric_columns = merged_data.select_dtypes(include=['float64', 'int64']).columns

# Round each numeric column to 2 decimal places
for column in numeric_columns:
    merged_data[column] = merged_data[column].round(2)

# Organize columns
column_order = [
    'Date',
    'CPI',
    'CPI_Monthly_Change_Pct',
    'CPI_YoY_Change_Pct',
    'Retail_Index',
    'Retail_Monthly_Change_Pct',
    'Retail_YoY_Change_Pct',
    'Retail_Index_Adjusted',
    'Consumer_Confidence',
    'Confidence_Change'
]

merged_data = merged_data[column_order]

output_filename = 'Retail_CPI_Merged.csv'
merged_data.to_csv(output_filename, index=False)