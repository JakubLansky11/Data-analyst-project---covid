create table le_1
select
	country,
	year,
	life_expectancy
from life_expectancy
where year = 1965

create table le_2
select
	country,
	year,
	life_expectancy
from life_expectancy
where year = 2015

create table life_expectancy_difference
select
	le_1.country,
	le_1.life_expectancy as life_exp_1,
	le_2.life_expectancy as life_exp_2,
	le_2.life_expectancy - le_1.life_expectancy as life_exp_diff
from le_1
join le_2 on le_2.country = le_1.country

create table t_countries_1
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

create table t_countries_2
select
	date,
	country,
	confirmed AS confirmed_inf,
	recovered,
	deaths
from covid19_basic as cb 
order by country

select *
from t_countries_1

select *
from t_countries_2

create table t_countries_3
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


select *
from t_countries_1

select *
from t_countries_2

select *
from t_countries_3
order by date

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
