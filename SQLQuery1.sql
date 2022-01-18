--select *
--from CovidDeaths
--where continent is not null
--order by 3,4


----select *
----from CovidVaccinations
----order by 3,4

---- select Data that we are going to be using

--select location, date, total_cases, new_cases,total_deaths, population
--from CovidDeaths
--order by 1,2

--looking at total cases vs Total deaths

--select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--from CovidDeaths
--where location like '%states%'
--order by 1,2

--looking at total case vs populations
--shows what percentage of population got covid

--select location, date, total_cases, population, (total_cases/ population)*100 as percentpopulationInfected

--from CovidDeaths
----where location like '%states%'
--order by 1,2


--Looking at countries with highest infection Rate compared to populations

--select location,  population,max(total_cases) as Highestinfectioncount,  max((total_cases/ population))*100 as percentpopulationInfected
--from CovidDeaths
----where location like '%states%'
--group by location, population
--order by percentpopulationInfected DESC

-- showing countries with highest death count per population

--select location,  population,max(cast(total_deaths as int)) as TotalDeathcount
--from CovidDeaths
----where location like '%states%'
--where continent is not null
--group by location, population
--order by TotalDeathcount desc

----showing continents with highest death count per population
----LET'S Break things down by continent

--select continent,max(cast(total_deaths as int)) as TotalDeathcount
--from CovidDeaths
----where location like '%states%'
--where continent is not null
--group by continent
--order by TotalDeathcount desc

--GLOBAL NUMBERS

--select  date, sum(new_cases) as total_cases,sum(cast(new_deaths AS int)) as total_deaths , sum(cast(new_deaths AS int))/sum(new_cases)  *100 as DeathPercentage
--from CovidDeaths
----where location like '%states%'
--where continent is not null
--group by date
--order by 1,2 

--looking at total population vs vacinations

select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated,
(RollingPeopleVaccinated/population)*100
from CovidDeaths as dea
join CovidVaccinations as vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null

order by 2,3

--useCTE

with popvsvac (continent, location, date,population,RollingPeopleVaccinated, new_vaccinations)
as
(
select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from CovidDeaths as dea
join CovidVaccinations as vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select* , (RollingPeopleVaccinated/population)*100
from popvsvac


--TEMP TABLE
DROP table if exists #PercentagePopulationVaccinated
create table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location  nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric, 

)


select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from CovidDeaths as dea
join CovidVaccinations as vac
     on dea.location = vac.location
     and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select* , (RollingPeopleVaccinated/population)*100
from #PercentagePopulationVaccinated

--Creationg data to store later for data visualizations

create view PercentagePopulationVaccinated as 
select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from CovidDeaths as dea
join CovidVaccinations as vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null
--order by 2,3

