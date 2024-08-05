
select *
from coviddeaths
where continent is not null
order by 3,4

update coviddeaths
set total_deaths = null
where total_deaths = '0';

update coviddeaths
set continent = null
where continent = '';

update covidvaccination
set new_vaccinations = null
where new_vaccinations = '';


select *
from covidvaccination
order by 3,4


SELECT 
    population,
    total_cases_per_million,
    ROUND(population * total_cases_per_million / 1000000) AS total_cases
FROM 
    coviddeaths;
    

ALTER TABLE coviddeaths
ADD COLUMN total_cases INT;


UPDATE coviddeaths
SET total_cases = ROUND(population * total_cases_per_million / 1000000);



select location,date, total_cases, new_cases, total_deaths, population
from coviddeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- shows likelyhood of dying from covid

select location, date,total_cases , total_deaths, (total_deaths/total_cases) * 100 as death_percentage 
from coviddeaths 
where location = 'germany'
and continent is not null
order by 1,2

-- looking at total cases vs population

select location, date, population,total_cases , (total_cases/population) * 100 as percent_population_infected
from coviddeaths 
-- where location = 'india'

-- Looking at Countries with Highest Infection Rate compared to Population

select location, population, max(total_cases) as highest_infection_count , max((total_cases/population)) * 100 as percent_population_infected
from coviddeaths 
group by location, population, continent
order by percent_population_infected desc

SELECT
    c.location,
    c.population,
    c.date,
    c.total_cases AS highest_infection_count,
    (c.total_cases / c.population) * 100 AS percent_population_infected
FROM
    coviddeaths c
JOIN
    (SELECT location, population, MAX(total_cases) AS max_cases
     FROM coviddeaths
     GROUP BY location, population) sub
ON
    c.location = sub.location AND
    c.population = sub.population AND
    c.total_cases = sub.max_cases
ORDER BY
    percent_population_infected DESC
LIMIT 50000;



WITH DateSeries AS (
    SELECT DISTINCT date
    FROM coviddeaths
),
LocationSeries AS (
    SELECT DISTINCT location, population
    FROM coviddeaths
),
AllCombinations AS (
    SELECT 
        ls.location,
        ls.population,
        ds.date
    FROM 
        LocationSeries ls
    CROSS JOIN 
        DateSeries ds
)
SELECT
    ac.location,
    ac.population,
    ac.date,
    COALESCE(cd.total_cases, 0) AS infection_count,
    (COALESCE(cd.total_cases, 0) / ac.population) * 100 AS percent_population_infected
FROM
    AllCombinations ac
LEFT JOIN
    coviddeaths cd
ON
    ac.location = cd.location AND ac.date = cd.date
ORDER BY
    ac.location,
    ac.date;


-- Showing Countries with Highest Death Count per Population

select location, max(total_deaths) as total_death_count
from coviddeaths
where continent is not null
group by location, continent
order by total_death_count desc


-- Showing Countries with Highest Death Count per continent
-- Showing contintents with the highest death count per population

SELECT continent, MAX(total_death_count) AS total_death_count
FROM (
    -- Subquery for non-null continents
    SELECT continent, MAX(total_deaths) AS total_death_count
    FROM coviddeaths
    WHERE continent IS NOT NULL
    GROUP BY continent

    UNION

    -- Subquery for null continents
    SELECT location AS continent, MAX(total_deaths) AS total_death_count
    FROM coviddeaths
    WHERE continent IS NULL
    GROUP BY location
) AS combined_results
GROUP BY continent
ORDER BY total_death_count DESC;

-- GLOBAL NUMBERS

select date,sum(new_cases) as totalnew_cases, sum(new_deaths) as totalnew_deaths,  sum(new_deaths)/sum(new_cases) * 100 as death_percentage
from coviddeaths 
where continent is not null 
group by date
order by 1,2

select sum(new_cases) as totalnew_cases, sum(new_deaths) as totalnew_deaths,  sum(new_deaths)/sum(new_cases) * 100 as death_percentage
from coviddeaths 
where continent is not null 
-- group by date
order by 1,2

-- Looking at Total Population vs Vaccinations

select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, sum(cv.new_vaccinations) 
over(partition by cd.location order by cd.location, cd.date) as rolling_people_vaccinated
from coviddeaths cd
join covidvaccination cv
on cd.location = cv.location 
and cd.date = cv.date
 where cv.continent is not null
order by 2,3

-- use CTE

with cpvscv (continent, location, date, population,new_vaccinations, rolling_people_vaccinated)
as
(
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, sum(cv.new_vaccinations) 
over(partition by cd.location order by cd.location, cd.date) as rolling_people_vaccinated
from coviddeaths cd
join covidvaccination cv
on cd.location = cv.location 
and cd.date = cv.date
 where cv.continent is not null
 )
 select *, (rolling_people_vaccinated/population) * 100
 from cpvscv


-- temp table

Drop table if exists percent_population_vaccinated;

create table percent_population_vaccinated
(
continent nvarchar (255),
location nvarchar (255),
date date,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
);

insert into percent_population_vaccinated
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, sum(cv.new_vaccinations) 
over(partition by cd.location order by cd.location, cd.date) as rolling_people_vaccinated
from coviddeaths cd
join covidvaccination cv
on cd.location = cv.location 
and cd.date = cv.date
where cv.continent is not null;

 select *, (rolling_people_vaccinated/population) * 100
 from percent_population_vaccinated;
 
 
-- SHOW VARIABLES LIKE 'net%timeout';

-- creating view to store data for later visulizations

create view percent_population_vaccinated as
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, sum(cv.new_vaccinations) 
over(partition by cd.location order by cd.location, cd.date) as rolling_people_vaccinated
from coviddeaths cd
join covidvaccination cv
on cd.location = cv.location 
and cd.date = cv.date



















