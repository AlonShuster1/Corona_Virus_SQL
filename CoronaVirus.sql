
SELECT *
FROM coviddeaths
WHERE continent IS NOT NULL
order by 3,4;


SELECT *
FROM coviddeaths
WHERE continent IS NOT NULL
order by 3,4;


-- select data that we are going to use
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
WHERE continent IS NOT NULL
order by 1, 2 DESC NULLS LAST;

-- looking at Total cases vs total Deaths
SELECT location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as death_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
order by 1, 2 DESC NULLS LAST;

-- Total cases vs total Deaths in israel
SELECT location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as death_percentage
FROM coviddeaths
WHERE continent IS NOT NULL AND location='Israel'
order by 2 DESC NULLS LAST;;

-- total cases vs population
SELECT location, date, total_cases, population, ((total_cases/population)*100) as cases_percatange
FROM coviddeaths
WHERE continent IS NOT NULL
order by 1, 2;

-- countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 as max_population_infected_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location, population
order by max_population_infected_percentage DESC NULLS LAST;

-- countries with highest death count per population
SELECT location, population, MAX(total_deaths) as highest_death_count, MAX((total_deaths/population))*100 as max_death_count_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location, population
order by max_death_count_percentage DESC NULLS LAST;

-- showing highest death count per continent
SELECT continent, MAX(total_deaths) as highest_death_count
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
order by highest_death_count DESC NULLS LAST;

-- deaths per day globally
SELECT date, SUM(new_cases) as cases_per_day, SUM(new_deaths) as deaths_per_day, (SUM(new_deaths)/SUM(new_cases))*100 as death_percentage
FROM coviddeaths
WHERE continent IS NOT NULL AND new_deaths IS NOT NULL
GROUP BY date
ORDER BY date;

--join vaccinations table with death table
SELECT cd.location, cv.location, cd.date, cv.date
FROM coviddeaths as cd
JOIN covidvaccinations as cv
ON cd.location = cv.location and cd.date=cv.date


-- *** USING CTE ***
WITH pop_vs_vac (continent, location, date, population, new_vaccinations, accumulating_people_vaccinated)
AS (
-- total population vs vaccination
SELECT  cd.continent, cd.location,cd.date,cd.population, cv.new_vaccinations
, SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as accumulating_people_vaccinated
FROM coviddeaths as cd
JOIN covidvaccinations as cv
ON cd.location = cv.location and cd.date=cv.date
WHERE cd.continent IS NOT NULL and cv.new_vaccinations>0
order by 2,3
)
SELECT *, ((accumulating_people_vaccinated/population)*100) as population_vaccinated_percentage
FROM pop_vs_vac


-- *** doing the same with 'NESTED QUERIES' ***
SELECT *, ((accumulating_people_vaccinated/population)*100) as population_vaccinated_percentage
FROM (
SELECT  cd.continent, cd.location,cd.date,cd.population, cv.new_vaccinations
, SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as accumulating_people_vaccinated
FROM coviddeaths as cd
JOIN covidvaccinations as cv
ON cd.location = cv.location and cd.date=cv.date
WHERE cd.continent IS NOT NULL and cv.new_vaccinations>0
order by 2,3) as pop_vs_vac


-- *** doing the same with 'TEMP TABLE' ***
CREATE TEMP TABLE Percent_population_vaccinated
(
	continent text,
	location text,
	date date,
	population numeric,
	new_vaccinations numeric,
	accumulating_people_vaccinated numeric
)

INSERT INTO Percent_population_vaccinated
SELECT  cd.continent, cd.location,cd.date,cd.population, cv.new_vaccinations
, SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as accumulating_people_vaccinated
FROM coviddeaths as cd
JOIN covidvaccinations as cv
ON cd.location = cv.location and cd.date=cv.date
WHERE cd.continent IS NOT NULL and cv.new_vaccinations>0
order by 2,3

SELECT *, ((accumulating_people_vaccinated/population)*100) as population_vaccinated_percentage
FROM Percent_population_vaccinated
 

















