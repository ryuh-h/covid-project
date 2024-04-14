/*
	Covid-19 Deaths & Vaccination data exploration.
	
	The purpose of this project is to extract useful insights from the 'Our World in Data COVID-19' dataset.
	Link: https://github.com/owid/covid-19-data/tree/master/public/data
	
	The data extracted will be used for further visualisation in future projects.
*/


-- ANALYSING DEATHS
-- BREAK DOWN BY COUNTRY

-- Total Deaths vs Total Cases
-- Shows death rate you contract covid in each country

SELECT location, ROUND((MAX(total_deaths)::DECIMAL / MAX(total_cases) * 100), 2) AS death_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
HAVING (MAX(total_deaths)::DECIMAL / MAX(total_cases)) IS NOT NULL
ORDER BY death_percentage DESC


-- Total Cases vs Population
-- Indicates how well each country suppressed the spread of Covid

SELECT location, ROUND((MAX(total_cases)::DECIMAL / MAX(population) * 100), 2) AS population_infect_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
HAVING (MAX(total_cases)::DECIMAL / MAX(population)) IS NOT NULL
ORDER BY population_infect_percentage DESC


-- Country with the highest infected and deaths

SELECT location, MAX(total_cases) AS total_cases, MAX(total_deaths) AS total_deaths
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
HAVING MAX(total_cases) IS NOT NULL
ORDER BY 2 DESC, 3 DESC



-- BREAK DOWN BY CONTINENT

-- Total Deaths vs Total Cases
-- Shows death rate you contract covid in your country

SELECT continent, ROUND((MAX(total_deaths)::DECIMAL / MAX(total_cases) * 100), 2) AS death_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
HAVING (MAX(total_deaths)::DECIMAL / MAX(total_cases)) IS NOT NULL
ORDER BY death_percentage DESC


-- Total Cases vs Population
-- Indicates how well each continent suppressed the spread of Covid

SELECT continent, ROUND((MAX(total_cases)::DECIMAL / MAX(population) * 100), 2) AS population_infect_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
HAVING (MAX(total_cases)::DECIMAL / MAX(population)) IS NOT NULL
ORDER BY population_infect_percentage DESC



-- GLOBAL NUMBERS

SELECT 
	SUM(new_cases) AS total_cases, 
	SUM(new_deaths) AS total_deaths,
	ROUND((SUM(new_deaths)::DECIMAL / SUM(new_cases) * 100), 2) AS global_death_percentage
FROM coviddeaths




-- ANALYSING VACCINATIONS

-- Popularity of vaccinations in each country

SELECT 
	v.location, 
	ROUND((MAX(v.total_vaccinations)::DECIMAL / MAX(d.population)), 2) AS vax_per_person,
	ROUND((MAX(v.people_fully_vaccinated)::DECIMAL / MAX(d.population) * 100), 2) AS vax_population_percentage	
FROM covidvax v
JOIN coviddeaths d
	on v.continent = d.continent AND v.location = d.location AND v.date = d.date
WHERE v.continent IS NOT NULL
GROUP BY 1
HAVING (MAX(v.total_vaccinations)::DECIMAL / MAX(d.population)) IS NOT NULL
ORDER BY vax_population_percentage DESC


-- Popularity of vaccinations in each continent

SELECT 
	v.continent, 
	ROUND((MAX(v.total_vaccinations)::DECIMAL / MAX(d.population)), 2) AS vax_per_person,
	ROUND((MAX(v.people_fully_vaccinated)::DECIMAL / MAX(d.population) * 100), 2) AS vax_population_percentage	
FROM covidvax v
JOIN coviddeaths d
	on v.continent = d.continent AND v.location = d.location AND v.date = d.date
GROUP BY 1
HAVING (MAX(v.total_vaccinations)::DECIMAL / MAX(d.population)) IS NOT NULL
ORDER BY vax_population_percentage DESC


-- Vaccinations-per-capita over time

SELECT 
	v.location,
	v.date,
	v.new_vaccinations,
	v.total_vaccinations,
	ROUND((SUM(v.new_vaccinations::DECIMAL) OVER (PARTITION BY v.location ORDER BY v.date) /
		   MAX(d.population) OVER (PARTITION BY v.location)), 2) AS rolling_vax_per_capita,
	d.population,
	v.people_vaccinated,
	v.people_fully_vaccinated
FROM covidvax v
JOIN coviddeaths d
	on v.continent = d.continent AND v.location = d.location AND v.date = d.date
ORDER BY v.location, v.date





