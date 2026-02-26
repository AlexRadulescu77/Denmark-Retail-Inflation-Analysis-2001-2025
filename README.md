# Denmark Retail & Inflation Analysis (2001–2025)

This project analyzes Denmark’s retail trade market and inflation trends from January 2001 to September 2025.

The objective was to examine how price changes (CPI) influence consumer purchasing behaviour, retail performance, and real purchasing power over time.

The project began as a Python + Power BI analysis and was later expanded into a Microsoft Power Platform solution including SharePoint, Power Apps and Power Automate.

---

## Dashboard Preview

### Page 1 – Inflation, Consumer Confidence & Real Retail Analysis
![Retail Dashboard Page 1](Visualization%20-%20PowerBI/dasboard1.png)

This page analyzes macroeconomic impact:

- CPI development (2001–2025)
- Annual inflation spikes
- Consumer confidence trends
- Nominal vs inflation-adjusted retail index
- Key KPI indicators (Latest CPI, Average Retail Index, Average Confidence)


### Page 2 – Quarterly Retail Growth Analysis
![Retail Dashboard Page 2](Visualization%20-%20PowerBI/dasboard2.png)

This page focuses on retail structure and seasonal patterns:

- Quarterly retail growth rates (YoY %)
- Long-term cumulative quarterly performance
- Identification of strongest and weakest quarters
- Impact of financial crisis and post-pandemic recovery


## Business Context

Retail performance does not only depend on demand, but also on price levels and consumer sentiment.

This project demonstrates how macroeconomic indicators (CPI, inflation, confidence) interact with retail sector performance and how inflation affects real purchasing power.

The analysis supports:

- Economic trend evaluation  
- Seasonal pattern identification  
- Real vs nominal performance comparison  
- Data-driven interpretation of crisis periods  

---

## Key Insights

### Inflation & CPI

- CPI increased ~60% from 76.7 (2001) to 122.5 (July 2025 peak)
- Latest CPI: 121.6 (September 2025)
- Average annual inflation (2001–2025): 1.8%
- Peak annual inflation: 7.7% (2022 – energy crisis)
- Peak monthly inflation: 10.1% (September 2022)
- Most stable inflation period: 2013–2016 (below 1%)

---

### Retail Sector Performance

- Average retail index: 91.81
- Worst year: 2009 (-47.22%, financial crisis)
- Strongest recovery: 2021 (+52.30%, post-pandemic rebound)
- December consistently highest retail month
- January typically lowest month (post-holiday decline)

---

### Consumer Confidence

- 25-year average: -0.11
- Lowest point: -37.0 (2022 energy crisis)
- Financial crisis low: -16.6 (2008–2009)
- Pandemic drop: -11.9 (2020), but faster recovery than 2008
- Recent crises show faster recovery patterns

---

### Quarterly Retail Patterns

- Q1 strongest cumulative growth: 157.39% (2002–2025)
- Q4 weakest cumulative growth: 100.14%
- Q1 shows higher volatility year-to-year
- Q4 more stable but slower overall growth
- 2009 negative across all quarters

---

### Inflation Impact on Real Purchasing Power

- Inflation-adjusted retail index consistently below nominal
- Significant gap widening during 2022–2023 inflation spike
- Consumers paid more but purchased less in real terms during high inflation

---

## Project Architecture

1. Data extracted from Statistics Denmark (dst.dk)
2. Three datasets merged in Python (CPI, Retail Index, Consumer Confidence)
3. 10 KPIs calculated including:
   - YoY growth rates
   - Inflation-adjusted retail index
   - Quarterly cumulative performance
4. Data stored in SharePoint as centralized cloud repository
5. Interactive exploration via Power Apps
6. Visualization in Power BI (two-page dashboard)
7. Workflow automation (Power Automate – in progress)

---

## Technologies Used

- Python (Pandas)
- SQL
- Power BI
- SharePoint (Cloud data storage)
- Power Apps (Interactive interface)
- Power Automate (Workflow automation – in progress)

---

## Data Source

Statistics Denmark (dst.dk)
