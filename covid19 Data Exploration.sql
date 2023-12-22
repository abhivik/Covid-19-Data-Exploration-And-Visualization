use Covid19db;

-- select COUNT(*) from coviddeaths;
-- select COUNT(*) from covidvaccinations;

select * from coviddeaths
where continent is not null 
order by 3,4;

-- select * from covidvaccinations
-- order by 3,4;

select location , date, total_cases, new_cases, total_deaths, population
from coviddeaths;

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

select location , date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location = 'India' and continent is not null
order by 2 DESC;


-- Looking at the total cases vs the population

select location , date, Population, total_cases, (total_cases/population)*100 as PercentOfPopulationInfected
from coviddeaths
where location = 'India' and continent is not null
order by 1, 2 DESC;


select location , Population, date, MAX(total_cases) as HighestInfectCount, MAX((total_cases/population))*100 as PercentOfPopulationInfected
from coviddeaths
group by location, Population, `date` 
order by PercentOfPopulationInfected desc;


-- Looking at countries with highest infection rate compared to population
select location , Population, MAX(total_cases) as HIghestInfectionCount, MAX((total_cases/population))*100 as PercentOfPopulationInfected
from coviddeaths
-- and continent is not null
group by location, population 
order by PercentOfPopulationInfected desc;


-- Countries with the Highest Death Count per Population
select location , MAX(total_deaths) as TotalDeathCount
from coviddeaths
where location not in ('World', 'High income', 'Upper middle income', 
					   'Europe', 'Asia', 'North America', 'South America', 
					   'Lower middle income', 'European Union', 'Africa')
group by location
order by TotalDeathCount desc;

-- Let's break things down by continent 
-- Showing the continents with highest death count
select location, MAX(total_deaths) as TotalDeathCount
from coviddeaths
where continent is not null
group by location
order by TotalDeathCount desc;

-- Global Numbers
select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, 
	   sum(new_deaths)/sum(new_cases)*100 as DeathPercentage -- total_cases , total_deaths , (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where continent is not null
-- group by date
order by 1, 2;

-- World EU and INternational
select location, SUM(new_deaths) as TotalDeathCount
from coviddeaths
where continent is null
and location not in('World', 'European Union', 'International')
group by location 
order by TotalDeathCount desc;

-- Looking at total population vs vaccination

select dea.continent, dea.location, dea.date, dea.population, 
	   vac.new_vaccinations, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)
from coviddeaths dea
join covidvaccinations vac on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3
limit 200;
