import pandas as pd
import mysql.connector
from mysql.connector import Error

# Load CSV
df = pd.read_csv(r'C:\Users\alexr\Desktop\Trade Index Data\Data\Clean data\Retail_CPI_Merged.csv')
#Connect to MySQL
try:
    
    connection = mysql.connector.connect(
        host='localhost',
        database='retail_analysis',
        user='root',
        password='Parola12345!@#'
    )
    
    if connection.is_connected():
        cursor = connection.cursor()
        
        # Clear existing data
       
        cursor.execute("TRUNCATE TABLE merged_analysis")
        
        # Insert row by row
        
        
        sql = """INSERT INTO merged_analysis 
                 (date, cpi_total, cpi_monthly_change_pct, cpi_yoy_change_pct,
                  retail_index_total, retail_monthly_change_pct, retail_yoy_change_pct,
                  retail_index_adjusted, consumer_confidence, confidence_change)
                 VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
        
        for index, row in df.iterrows():
            # Convert NaN to None for SQL NULL
            values = tuple(None if pd.isna(x) else x for x in row)
            cursor.execute(sql, values)
            
            if (index + 1) % 50 == 0:
                print(f"   Inserted {index + 1} rows")
        
        connection.commit()
        
        # Verify
        cursor.execute("SELECT COUNT(*) FROM merged_analysis")
        count = cursor.fetchone()[0]
        
        cursor.execute("SELECT MIN(date), MAX(date) FROM merged_analysis")
        date_range = cursor.fetchone()
        
        print(f"   Rows in database: {count}")
        print(f"   Date range: {date_range[0]} to {date_range[1]}")
        
        if count == len(df):
            print("\n All rows imported correctly")
        else:
            print(f"\n Expected {len(df)} rows but got {count}")
        
except Error as e:
    print(f" Error: {e}")
    
finally:
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("\n MySQL connection closed")
