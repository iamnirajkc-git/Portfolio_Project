#select all columns from Covid death table
select * 
from PortfolioProject..CovidDeaths
order by 3, 4


select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1, 2


#Total Cases VS Total Deaths
#Total Percentage of death in covid patients in USA
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1, 2


#Total Covid Cases in Total Poulation
select location, date, total_cases, population, (total_cases/population)*100 as InfectionPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2 

#Country with heighest infection rate as compared to its population
select location, population, MAX(total_cases) as HeighestInfectionCount, max(total_cases/population)*100 as InfectionPercentage
from Portfolioproject..CovidDeaths
where continent is not null
group by location, population
order by  InfectionPercentage desc

--Showing countries with heighest death count  per population
SELECT location, Max(cast(total_deaths as int)) as TotalDeathCount 
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc 

---Now showing Death per continent

SELECT continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--Global numbers death percentage  per day
Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1, 2

--Global number death percentage in total
Select  sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1, 2


--USE of CTE 
--Looking at Total population VS vaccinated

WITH PopsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinatedDateWise)
as
(
SELECT  dea.continent, dea.location, dea.date, dea.population, cast(vac.new_vaccinations as int) as DateWiseVaccinated,
sum(CONVERT(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinatedDateWise
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	on dea.location =vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2, 3
)
select *, (RollingPeopleVaccinatedDateWise/population)*100 
from PopsVac

---Creating view to store data for later visualization
Create view  PopsVac as
SELECT  dea.continent, dea.location, dea.date, dea.population, cast(vac.new_vaccinations as int) as DateWiseVaccinated,
sum(CONVERT(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinatedDateWise
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	on dea.location =vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2, 3


select * from PopsVac





