/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select *
From CovidDeaths 
Where continent is not null 
order by 3,4;


select *
from CovidVaccinations
order by 3,4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Where continent is not null 
order by 1,2



-- Looking at Total Cases vs. Total Deaths
-- Shows likelihood of dying if you contract Covid-19 in Canada during January 2020 - April 2021

Select Location, date, total_cases, total_deaths, 
(total_deaths/total_cases)*100 as Death_Percentage
from CovidDeaths
where location like 'Canada'
and continent is not null
order by 1,2



-- Looking at Total Cases vs. Population
-- Shows what percentage of population got covid

Select Location, date, Population, total_cases, total_deaths, 
(total_cases/population)*100 as Percent_Population_Infected
from CovidDeaths
where location like 'Canada'
order by 1,2


-- Looking at countries with Higest Infection Rate compared to Population

Select Location, Population, max(total_cases) as Highest_Infection_Count, 
max((total_cases/population))*100 as Percent_Population_Infected
from CovidDeaths
group by Location, Population
order by Percent_Population_Infected desc



-- Countries with Highest Death Count per Population

Select Location, max(cast(total_deaths as int)) as Total_Death_Count
from CovidDeaths
where continent is not null
group by Location
order by Total_Death_Count desc



-- Breakdown by Continent

Select location, max(cast(total_deaths as int)) as Total_Death_Count
from CovidDeaths
where continent is null
group by location
order by Total_Death_Count desc



-- Showing contintents with the highest death count per population

Select continent, max(cast(total_deaths as int)) as Total_Death_Count
from CovidDeaths
where continent is not null
group by continent
order by Total_Death_Count desc




-- Looking at Global numbers

Select SUM(new_cases) as Total_Cases, 
SUM(cast(new_deaths as int)) as Total_Deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as Death_Percentage
From CovidDeaths
where continent is not null 
order by 1,2



-- Total Population vs. Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3



-- With CTE 

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
select *, (Rolling_People_Vaccinated/Population)*100
from PopvsVac




-- Using Temp Table to perform Calculation on Partition By in previous query


DROP Table if exists #PercentPopulationVaccinated  -- In case if alterations are needed for the temp table


Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_People_Vaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date


Select *, (Rolling_People_Vaccinated/Population)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

