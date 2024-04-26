select *
from [portfolio project]..CovidDeaths
where continent is not null
order by 3,4

select location , date , total_cases, new_cases, total_deaths, population
from [portfolio project]..CovidDeaths
order by 1,2

select location ,date, total_cases, total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from [portfolio project]..CovidDeaths
where location like '%non%'
order by 1,2

select location ,date, total_cases,population,(total_cases/population)*100 as inpercentage
from [portfolio project]..CovidDeaths
where location like '%non%'
order by 1,2

select location , max(total_cases) as HighestInfectioncount,population,max(total_cases/population)*100 as PercentpopulationInfected
from [portfolio project]..CovidDeaths
group by location, population
order by PercentpopulationInfected desc


select location , max(cast(total_deaths as int)) as TotalDeathCount
from [portfolio project]..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


select continent, max(cast(total_deaths as int)) as TotalDeathCount
from [portfolio project]..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [portfolio project]..CovidDeaths
where continent is not null
order by 1,2

select *
from [portfolio project]..Covidvaccination

select *
from [portfolio project]..CovidDeaths dea
join [portfolio project]..Covidvaccination vac
 on dea.date=vac.date
 and dea.location=vac.location

 select dea.continent, dea.location ,dea.date,dea.population,vac.new_vaccinations,SUM(convert(int,vac.new_vaccinations)) over
 (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [portfolio project]..CovidDeaths dea
join [portfolio project]..Covidvaccination vac
 on dea.date=vac.date
 and dea.location=vac.location
where dea.continent is not null
 order by 2,3

 with popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
 as
 ( select dea.continent, dea.location ,dea.date,dea.population,vac.new_vaccinations,SUM(convert(int,vac.new_vaccinations)) over
 (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [portfolio project]..CovidDeaths dea
join [portfolio project]..Covidvaccination vac
 on dea.date=vac.date
 and dea.location=vac.location
where dea.continent is not null
 )
 select *,(RollingPeopleVaccinated/population)*100
 from popvsvac
 
 drop table if exists #percentpopulationvaccinated
 create table #percentpopulationvaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 Date datetime,
 population numeric,
 new_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )


 insert into  #percentpopulationvaccinated
  select dea.continent, dea.location ,dea.date,dea.population,vac.new_vaccinations,SUM(convert(int,vac.new_vaccinations)) over
 (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [portfolio project]..CovidDeaths dea
join [portfolio project]..Covidvaccination vac
 on dea.date=vac.date
 and dea.location=vac.location
where dea.continent is not null

 select *, RollingPeopleVaccinated
 from  #percentpopulationvaccinated
 
 Create View percentpopulationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [portfolio project]..CovidDeaths dea
Join [portfolio project]..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

select *
from percentpopulationvaccinated