import pandas as pd
import numpy as np
import os

# Set working directory
os.chdir(r'C:\Users\alexr\Desktop\Trade Index Data\Data\Clean data')

# Verify the right place
print(f"Current directory: {os.getcwd()}")
print(f"Files in directory: {os.listdir()}")

# Load all three clean datasets
cpi_df = pd.read_csv('CPI_Clean.csv')
retail_df = pd.read_csv('Retail_Clean.csv')
confidence_df = pd.read_csv('Consumer_Confidence_Clean.csv')

# Convert Date columns to datetime
cpi_df['Date'] = pd.to_datetime(cpi_df['Date'])
retail_df['Date'] = pd.to_datetime(retail_df['Date'])
confidence_df['Date'] = pd.to_datetime(confidence_df['Date'])

#Filter for main categories

# Keep only "Total" categories for main analysis
cpi_total = cpi_df[cpi_df['Category'] == '00 Total'].copy()
retail_total = retail_df[retail_df['Category'] == 'Retail trade total'].copy()

# Rename columns for clarity
cpi_total = cpi_total.rename(columns={'CPI': 'CPI_Total'})
retail_total = retail_total.rename(columns={'Retail_Index': 'Retail_Index_Total'})

# Merge datasets

# Consumer confidence (has all dates)
merged_df = confidence_df.copy()

# Merge with CPI data
merged_df = merged_df.merge(
    cpi_total[['Date', 'CPI_Total']], 
    on='Date', 
    how='left'
)

# Merge with Retail data
merged_df = merged_df.merge(
    retail_total[['Date', 'Retail_Index_Total']], 
    on='Date', 
    how='left'
)

print(f"Merged dataset created: {len(merged_df)} rows, {len(merged_df.columns)} columns")
print(f"\nColumns: {list(merged_df.columns)}")

# Check for missing values

missing_counts = merged_df.isnull().sum()
print("\nMissing values per column:")
print(missing_counts)

if missing_counts.sum() > 0:
    print(f"\n Total missing values: {missing_counts.sum()}")
    
    # Show rows with missing data
    print("\nRows with missing data:")
    print(merged_df[merged_df.isnull().any(axis=1)])
    
    # Fill missing values using forward fill (carry last known value)

    merged_df = merged_df.fillna(method='fill')
    
    # Check again
    remaining_missing = merged_df.isnull().sum().sum()
    if remaining_missing > 0:
        print(f" Still {remaining_missing} missing values.")
        merged_df = merged_df.fillna(method='bfill')
    
    print(" All missing values are filled now")
else:
    print(" No missing values found")


# Create calculated columns

# Monthly percentage change for CPI
merged_df['CPI_Monthly_Change_Pct'] = merged_df['CPI_Total'].pct_change() * 100

# Monthly percentage change for Retail Index
merged_df['Retail_Monthly_Change_Pct'] = merged_df['Retail_Index_Total'].pct_change() * 100

# Adjusted Retail Index (Real Retail Index)
# Formula: (Retail Index / CPI) * 100

merged_df['Retail_Index_Adjusted'] = (merged_df['Retail_Index_Total'] / merged_df['CPI_Total']) * 100

# Year-over-Year CPI Change (12 months)
merged_df['CPI_YoY_Change_Pct'] = merged_df['CPI_Total'].pct_change(periods=12) * 100

# Year-over-Year Retail Change
merged_df['Retail_YoY_Change_Pct'] = merged_df['Retail_Index_Total'].pct_change(periods=12) * 100

# Consumer Confidence Change
merged_df['Confidence_Change'] = merged_df['Consumer_Confidence'].diff()

# Round all numeric columns to 2 decimal places
numeric_columns = merged_df.select_dtypes(include=[np.number]).columns
merged_df[numeric_columns] = merged_df[numeric_columns].round(2)

# Reorder columns for clarity

column_order = [
    'Date',
    'CPI_Total',
    'CPI_Monthly_Change_Pct',
    'CPI_YoY_Change_Pct',
    'Retail_Index_Total',
    'Retail_Monthly_Change_Pct',
    'Retail_YoY_Change_Pct',
    'Retail_Index_Adjusted',
    'Consumer_Confidence',
    'Confidence_Change'
]

merged_df = merged_df[column_order]

# Preview some of the data

print("DATA PREVIEW")

print("\n First 10 rows:")
print(merged_df.head(10).to_string(index=False))

print("\n Last 10 rows:")
print(merged_df.tail(10).to_string(index=False))

# Save data set

merged_df.to_csv('Retail_CPI_Merged.csv', index=False)
print("Saved as: Retail_CPI_Merged.csv")