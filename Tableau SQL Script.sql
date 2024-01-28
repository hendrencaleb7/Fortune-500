Viz 1
'Companies with most top 10 spots
Bar Chart'
SELECT name, count(position) as 'Appearances'
FROM fortune_500.data_
Where position < 11
Group by name
Order by count(position) desc
Limit 10

Viz 2 
'Average Rev, mv, profit, employees per year
Line Graph'
USE `fortune_500`;
CREATE OR REPLACE VIEW `average_rev_mv_profit_employees_by_year` AS
    SELECT 
        year,
        AVG(revenue_mil) AS avg_rev_mil,
        AVG(market_value_mil) AS avg_mv_mil,
        AVG(profit_mil) AS avg_profit_mil,
        AVG(employees) AS avg_employees
    FROM
        fortune_500.data_
    GROUP BY year
    ORDER BY year ASC;;

Viz 3 
'Average Growth per year
Line Graph'
USE `fortune_500`;
CREATE OR REPLACE VIEW `growth_average_rev_mv_profit_employees_by_year` AS
Select year, 
avg_rev_mil, 
Lag(avg_rev_mil, 1) Over(order by year asc) as previous_year_rev, 
(avg_rev_mil/Lag(avg_rev_mil, 1) Over(order by year asc))*100-100 as percent_rev_growth, 
avg_mv_mil,
Lag(avg_mv_mil, 1) Over(order by year asc) as previous_year_mv, 
(avg_mv_mil/Lag(avg_mv_mil, 1) Over(order by year asc))*100-100 as percent_mv_growth,
avg_profit_mil,
Lag(avg_profit_mil, 1) Over(order by year asc) as previous_year_profit, 
(avg_profit_mil/Lag(avg_profit_mil, 1) Over(order by year asc))*100-100 as percent_profit_growth,
avg_employees,
Lag(avg_employees, 1) Over(order by year asc) as previous_year_employees, 
(avg_employees/Lag(avg_employees, 1) Over(order by year asc))*100-100 as percent_employees_growth
FROM fortune_500.average_rev_mv_profit_employees_by_year;

Select year, percent_rev_growth, percent_mv_growth,
percent_profit_growth, percent_employees_growth
From fortune_500.growth_average_rev_mv_profit_employees_by_year

Viz 4 
'Top 10 average rev, mv, profit, and employees difference with bottom 490
Line Grapgh'
Select year, AVG(revenue_mil) as avg_rev_mil, 
AVG(market_value_mil) as avg_mv_mil,
AVG(profit_mil) as avg_profit_mil, 
AVG(employees) as avg_employees
From fortune_500.data_  
Where position < 11
Group By year
Order by year asc

Select year, AVG(revenue_mil) as avg_rev_mil, 
AVG(market_value_mil) as avg_mv_mil,
AVG(profit_mil) as avg_profit_mil, 
AVG(employees) as avg_employees
From fortune_500.data_  
Where position > 10
Group By year
Order by year asc

(Sector)
Viz 5 
'Average Revenue, Market Value, Profit, employees and revenue per employee by business sector and year
Parallel Coordinate '

USE `fortune_500`;
CREATE OR REPLACE VIEW `average_rev_mv_profit_employees_by_sector_year` AS
    SELECT 
        sector,
        year,
        AVG(revenue_mil) AS avg_rev_mil,
        AVG(market_value_mil) AS avg_mv_mil,
        AVG(profit_mil) AS avg_profit_mil,
        AVG(employees) AS avg_employees
    FROM
        fortune_500.data_
    WHERE
        sector IS NOT NULL
    GROUP BY sector , year;;

Select sector, year, avg_rev_mil, avg_mv_mil, avg_profit_mil, 
avg_employees, (avg_rev_mil/avg_employees)*1000000 as revenue_per_employee
From fortune_500.average_rev_mv_profit_employees_by_sector_year

Viz 6 
'(GROWTH) Average Revenue, Market Value, Profit, employees and PE by business sector and year
parallel coordinate'
Create Table fortune_500.annual_growth_by_sector as
Select sector, year, 
avg_rev_mil, 
Lag(avg_rev_mil, 1) Over(order by sector, year asc) as previous_year_rev, 
(avg_rev_mil/Lag(avg_rev_mil, 1) Over(order by sector, year asc))*100-100 as percent_rev_growth, 
avg_mv_mil,
Lag(avg_mv_mil, 1) Over(order by sector, year asc) as previous_year_mv, 
(avg_mv_mil/Lag(avg_mv_mil, 1) Over(order by sector, year asc))*100-100 as percent_mv_growth,
avg_profit_mil,
Lag(avg_profit_mil, 1) Over(order by sector, year asc) as previous_year_profit, 
(avg_profit_mil/Lag(avg_profit_mil, 1) Over(order by sector, year asc))*100-100 as percent_profit_growth,
avg_employees,
Lag(avg_employees, 1) Over(order by sector, year asc) as previous_year_employees, 
(avg_employees/Lag(avg_employees, 1) Over(order by sector, year asc))*100-100 as percent_employees_growth
FROM fortune_500.average_rev_mv_profit_employees_by_sector_year;

SET SQL_SAFE_UPDATES = 0;

Update annual_growth_by_sector
Set previous_year_rev = null, percent_rev_growth = null, 
previous_year_mv = null, percent_mv_growth = null,
previous_year_profit = null, percent_profit_growth = null,
previous_year_employees = null, percent_employees_growth = null
Where year = 2015

SELECT sector, year, percent_rev_growth, percent_mv_growth,
percent_profit_growth, percent_employees_growth, avg_mv_mil/avg_profit_mil as avg_PE
FROM fortune_500.annual_growth_by_sector;
Viz 7 
'sector composition 
Pie chart'
-- Sector Total 2015-2023 --
SELECT COUNT(sector) AS sector_total
FROM fortune_500.data_
=4243

'Composition'
SELECT sector, COUNT(sector) AS frequency, 
count(sector)/4243 * 100 as freq_percent
FROM fortune_500.data_
GROUP BY sector


Viz 8 
'State composition
Geo Chart'
-- State Total 1996-2023 --
SELECT COUNT(hq_state) AS state_total
FROM fortune_500.data_
=13614

'Composition'
SELECT hq_state, COUNT(hq_state) AS frequency, 
count(hq_state)/13614 * 100 as freq_percent
FROM fortune_500.data_
GROUP BY hq_state

Viz 9 
'Top 5 state sector composition 
pie chart'

-- Top 5 States By % of HQs --
('NY' ,'CA', 'TX','IL', 'OH')

'New York'
-- NY Sector Total 1996-2023 --
SELECT COUNT(sector) AS sector_total
FROM fortune_500.data_
Where hq_state = 'NY'
= 457

-- NY Sector Frequency --
SELECT sector, COUNT(sector) AS frequency, 
count(sector)/457 * 100 as freq_percent
FROM fortune_500.data_
Where hq_state = 'NY'
GROUP BY sector

'California'
-- CA Sector Total 2015-2023 --
SELECT COUNT(sector) AS sector_total
FROM fortune_500.data_
Where hq_state = 'CA'
= 448

-- CA Sector Frequency --
SELECT sector, COUNT(sector) AS frequency, 
count(sector)/448 * 100 as freq_percent
FROM fortune_500.data_
Where hq_state = 'CA'
GROUP BY sector

'Texas'
-- TX Sector Total 2015-2023 --
SELECT COUNT(sector) AS sector_total
FROM fortune_500.data_
Where hq_state = 'TX'
= 442

-- TX Sector Frequency --
SELECT sector, COUNT(sector) AS frequency, 
count(sector)/442 * 100 as freq_percent
FROM fortune_500.data_
Where hq_state = 'TX'
GROUP BY sector

'Illinois'
-- IL Sector Total 2015-2023 --
SELECT COUNT(sector) AS sector_total
FROM fortune_500.data_
Where hq_state = 'IL'
= 313

-- IL Sector Frequency --
SELECT sector, COUNT(sector) AS frequency,
count(sector)/313 * 100 as freq_percent
FROM fortune_500.data_
Where hq_state = 'IL'
GROUP BY sector

'Ohio'
-- OH Sector Total 2015-2023 --
SELECT COUNT(sector) AS sector_total
FROM fortune_500.data_
Where hq_state = 'OH'
= 203

-- OH Sector Frequency --
SELECT sector, COUNT(sector) AS frequency, 
count(sector)/203 * 100 as freq_percent
FROM fortune_500.data_
Where hq_state = 'OH'
GROUP BY sector

Viz 10
'Newcomer percentage
single value chart'

Select Count(newcomer) as 'not new comer'
FROM fortune_500.data_
Where newcomer = 'no'
= 4011

Select Count(newcomer) as 'newcomer', Count(newcomer)+4011 as 'total', 
Count(newcomer)/(Count(newcomer)+4011) * 100 as 'newcomer_percent'
FROM fortune_500.data_
Where newcomer = 'yes'

Viz 11
'female ceo percentage average rev, mv, profit, and employees 
bar or column chart'
Select Count(female_ceo) as 'no female ceo'
FROM fortune_500.data_
Where female_ceo = 'no'
= 3953

'female_ceo'
Select Count(female_ceo)/(Count(female_ceo)+3953) * 100 as 'female_ceo_percent',
AVG(revenue_mil), AVG(market_value_mil), 
AVG(profit_mil), AVG(market_value_mil)/AVG(profit_mil) as 'AVG(pe)', AVG(employees)
FROM fortune_500.data_
Where female_ceo = 'yes'

'non_female_ceo'
Select AVG(revenue_mil), AVG(market_value_mil), 
AVG(profit_mil), AVG(market_value_mil)/AVG(profit_mil) as 'AVG(pe)', AVG(employees)
FROM fortune_500.data_
Where female_ceo = 'no'
