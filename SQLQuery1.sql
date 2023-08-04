select *
from PortfolioProject39..CovidDeaths
Where continent is not null
order by 3,4

select *
from PortfolioProject39..CovidVaccinations
order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject39..CovidDeaths
Where continent is not null
order by 1,2


Select Location, date, total_cases, total_deaths, (cast(total_deaths as decimal))/(cast(total_cases as decimal))*100 as DeathPercentage
From PortfolioProject39..CovidDeaths
--Where location like'%states%'
and continent is not null
order by 1,2


Select Location, date, population,  total_cases, (cast(total_deaths as decimal))/(cast(population as decimal))*100 as DeathPercentage
From PortfolioProject39..CovidDeaths
--Where location like'%states%'
order by 1,2

Select Location, population, MAX(total_cases) as HighestInfectionCount, Max(cast(total_deaths as decimal))/(cast(population as decimal))*100 as PercentPopulationInfected
from PortfolioProject39..CovidDeaths
--Where location like'%states%'
Group by Location, population
order by PercentPopulationInfected desc



Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject39..CovidDeaths
--Where location like'%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc



Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject39..CovidDeaths
--Where location like'%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject39..CovidDeaths
--Where location like'%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc



SELECT date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, SUM(new_deaths)/sum(nullif(new_cases,0))*100 as death_percentage
FROM PortfolioProject39..CovidDeaths
--Where location like '%states%'
WHERE continent is not null 
GROUP BY date
ORDER BY 1,2



Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject39..CovidDeaths dea
Join PortfolioProject39..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVacccinated)
as  
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject39..CovidDeaths dea
Join PortfolioProject39..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVacccinated/Population)*100
From PopvsVac




DROP TABLE if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject39..CovidDeaths dea
Join PortfolioProject39..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject39..CovidDeaths dea
Join PortfolioProject39..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3



Select *
From PercentPopulationVaccinated