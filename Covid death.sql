use project;
SELECT 
    *
FROM
    project.coviddeaths
ORDER BY 3 , 4;

SELECT 
    *
FROM
    project.covidvaccination
ORDER BY 3 , 4;

SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    project.coviddeaths
ORDER BY 1 , 2;

-- Looking at total cases vs total deaths
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    round((total_deaths / total_cases) * 100,2) AS DeathsPercentage
FROM
    project.coviddeaths
ORDER BY 1 , 2;

-- total cases and total deaths in New Zealand

SELECT 
    location,
    date,
    total_cases,total_deaths,
    ROUND((total_deaths / total_cases) * 100, 2) AS DeathPercentage
FROM
    project.coviddeaths
WHERE
    location = 'New Zealand'
ORDER BY 1 , 2;

-- Looking at total cases vs population

SELECT 
    location,
    date,
    population,
    total_cases,
    ROUND(( total_cases/population) * 100, 2) AS Caseperpopulation
FROM
    project.coviddeaths

ORDER BY 1 , 2;

#Looking at countries with highest infection rate compared to population

SELECT 
    location,
    population,
    MAX(total_cases) AS HighestInfectioncount,
    MAX((total_cases / population)) * 100 AS Percentagepopulationinfected
FROM
    project.coviddeaths
GROUP BY location , population
ORDER BY Percentagepopulationinfected DESC;

select location, max(total_deaths )as totaldeathcount
from project.coviddeaths
where continent is not null
group by location
order by totaldeathcount desc;


select Location, max(cast(total_deaths as SIGNED integer)) as TotalDeathCount
From project.coviddeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc;


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT 
    continent,
    MAX(CAST(Total_deaths AS SIGNED INT)) AS TotalDeathCount
FROM
    project.coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as signed int)) as total_deaths, round(SUM(cast(new_deaths as signed int))/SUM(New_Cases)*100) as DeathPercentage
From project.coviddeaths
where continent is  not null 
order by 1,2;


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select D.continent, D.location, D.date, D.population, V.new_vaccinations
, SUM(cast( V.new_vaccinations as signed int)) OVER (Partition by D.Location Order by D.location, D.Date) as RollingPeopleVaccinated
From project.coviddeaths D
Join project.covidvaccination V
	On D.location = V.location
	and D.date = V.date
where D.continent is not null 
order by 2,3;

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select D.continent, D.location, D.date, D.population, V.new_vaccinations
, SUM(cast(V.new_vaccinations as signed int)) OVER (Partition by D.Location Order by D.location, D.Date) as RollingPeopleVaccinated

From project.coviddeaths D
Join project.covidvaccination V
	On D.location = V.location
	and D.date = V.date
where D.continent is not null 


)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac





