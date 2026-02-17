## Denmark-Retail-Inflation-Analysis-2001-2025
This project analyzes Denmark's retail trade market and inflation trends from January 2001 to September 2025. The goal was to understand how price changes (measured by CPI) affect consumer purchasing behavior and retail sector performance over time.
I started with Python + Power BI analysis and later I expanded into a Microsoft Power Platform solution, integrating SharePoint for cloud data storage, Power Apps for an interactive user interface and now I'm working on Power Automate for workflow automation.

##Key Insights

Inflation & CPI
1. CPI increased 60% from 76.7 (January 2001) to 122.5 (July 2025 peak)
2. Latest CPI: 121.6 (September 2025)
3. Average annual inflation: 1.8% across the entire 25 year period
4. Peak annual inflation: 7.7% (2022 - energy crisis)
5. Peak monthly inflation: 10.1% (September 2022)
6. Most stable period: 2013-2016 with annual rates below 1%

Retail Sector Performance
1. Average retail index: 91.81 
2. Worst year: 2009 with -47.22% decline (financial crisis)
3. Strongest recovery: 2021 with +52.30% growth (post-pandemic)
4. December consistently highest month for retail sales
5. January typically lowest month following holiday season

Consumer Confidence
1. 25-year average: -0.11 
2. Lowest point: -37.0 (2022 energy crisis - worse than any previous crisis)
3. Financial crisis (2008-2009)- Confidence dropped to -16.6
4. Pandemic (2020): Fast drop to -11.9, but recovered faster than 2008
5. Pattern: Recent crises show faster recovery times

Quarterly Patterns
1. Q1 strongest cumulative growth: 157.39% (2002-2025)
2. Q4 weakest cumulative growth: 100.14% (2002-2025)
3. Q1 grew the most in total but fluctuates a lot year-to-year., while Q4 grows less overall but is more consistent
4. 2009 worst year across all quarters (financial crisis impact visible in all periods)

Inflation Impact on Real Purchasing Power
1. Real (inflation-adjusted) retail index consistently below nominal
2. Gap widened significantly 2022-2023 during high inflation period
3. Consumers paid more but bought less in real terms during inflation spikes


##Technologies Used

Data is processed with Python, stored in SharePoint, explored via Power Apps and visualized in Power BI.

 Python - Merges 3 datasets, calculates 10 KPIs including YoY growth and inflation-adjusted retail index
 SharePoint - Stores 297 processed records as centralized cloud repository
 Power Apps - Interactive data viewer with 4 filters, Year search and 5 KPI cards
 Power BI - Two-page dashboard showing CPI trends, quarterly retail patterns, nominal vs real retail comparison and consumer confidence analysis
 Power Automate - Automated processes (In progress)


##Data Source
Statistics Denmark (dst.dk) 
