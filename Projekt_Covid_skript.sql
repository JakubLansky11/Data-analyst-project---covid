-- these tables contain statistic of life expectency in different countries and it´s comparison between year 1965 and 2015
create or replace table le_1
select
	country,
	year,
	life_expectancy
from life_expectancy
where year = 1965

create or replace table le_2
select
	country,
	year,
	life_expectancy
from life_expectancy
where year = 2015

create or replace table life_expectancy_difference
select
	le_1.country,
	le_1.life_expectancy as life_exp_1,
	le_2.life_expectancy as life_exp_2,
	le_2.life_expectancy - le_1.life_expectancy as life_exp_diff
from le_1
join le_2 on le_2.country = le_1.country

-- creating of table which contains information about countries like population density, median age or child mortality
create or replace table t_countries_1
select
	c.country,
	capital_city,
	GDP as GDP_2019,
	e.population as Population_2019,
	e.population / surface_area as Population_density_2019,
	gini as GINI_2019,
	mortaliy_under5 as Child_mortality_2019,
	median_age_2018,
	life_exp_diff
from economies as e
join countries as c on c.country = e.country
join life_expectancy_difference as led on led.country = e.country
where year = 2019
order by c.country

-- creating of table which contains information about numbers of covid infected people and numbers of recovered and death people on covid
create or replace table t_countries_2
select
	date,
	country,
	confirmed AS confirmed_inf,
	recovered,
	deaths
from covid19_basic as cb 
order by country

-- creating of table which contains informations from previous tables
create or replace table t_countries_3
select
	date,
	t1.country,
	capital_city,
	GDP_2019,
	population_2019,
	population_density_2019 ,
	GINI_2019,
	child_mortality_2019,
	median_age_2018,
	life_exp_diff,
	confirmed_inf,
	recovered,
	deaths
from t_countries_2 as t2
join t_countries_1 as t1 on t1.country = t2.country
order by t1.country

-- show tables
select *
from t_countries_1

select *
from t_countries_2

select *
from t_countries_3
order by date

/* this query shows numbers of infected, recovered and dead people on covid in different countries in the last day (in the table, statistic ended in may 2021)
- ordered by number of dead people on covid from the highest to the lowest
- you can look at other statistics in the table if there is some correlation with number of dead or infected people
- data in table_1.csv
- whole data in countries, covid.csv
 */
select *
from t_countries_3
where date like (select max(date) from t_countries_3)
order by deaths DESC
	
/* this query provides information about weather in different cities and in different days 
weekday - 1 Monday to Friday, 0 - Saturday or Sunday
period of year - 0 Spring, 1 Summer, 2 Autumn, 3 Winter
- data in weather.csv
*/
select
	date(date) AS date,
	city,
	MAX(gust) AS max_gust,
	AVG(temp) AS average_daily_temp,
	AVG(rain) AS average_daily_rain,
	CASE 
		WHEN weekday(date) LIKE 5 OR weekday(date) LIKE 6 THEN "0"
		ELSE "1"
	END AS weekday,
	CASE 
		WHEN month(date) like 4 OR month(date) like 5 OR (day(date) < 22 AND month(date) like 6) OR (day(date) > 20 AND month(date) like 3) THEN "0"
		WHEN month(date) like 7 OR month(date) like 8 OR (day(date) < 22 AND month(date) like 9) OR (day(date) > 20 AND month(date) like 6) THEN "1"
		WHEN month(date) like 10 OR month(date) like 11 OR (day(date) < 22 AND month(date) like 12) OR (day(date) > 20 AND month(date) like 9) THEN "2"
		ELSE "3"
	END AS period_of_year
from weather AS w 
where (year(date) = 2020 OR year(date) = 2021) AND city IS NOT null
group by city, date
order by city, date
