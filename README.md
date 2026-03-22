# COVID-19_Data_Analysis

## 📌 Project Overview

This project analyzes the global COVID-19 data from Jan. 2020 to Apr. 2021 using **Excel, Microsoft SQL Server, and Tableau** to uncover trends in:

* Global cases and deaths
* Death percentage
* Infection rates by country
* Deaths by continent
* Percent population infected over time

The goal was not just to build a dashboard — but to demonstrate:

* Data cleaning & transformation
* Database normalization concepts
* Advanced SQL querying
* Analytical thinking
* Business-ready data visualization

---

## 🛠 Tech Stack

* **Microsoft Excel** – Data cleaning & restructuring
* **Microsoft SQL Server** – Data modeling & analysis
* **Tableau** – Data visualization & dashboard design

---

## 📂 Dataset Structure

The original dataset was restructured to simulate real-world database design.

### Excel Data Preparation

#### 1️⃣ Relocated Population Column

The `population` column was moved to the beginning of the dataset to:

* Improve schema clarity
* Reduce repeated JOIN operations
* Optimize query readability

---

#### 2️⃣ Created Two Separate Tables

To demonstrate database normalization and JOIN operations, the dataset was split into:

- <a href="https://github.com/YTFarhan/COVID-19_Data_Analysis/blob/main/CovidDeaths.xlsx">CovidDeaths</a>
`

Contains:

* Location
* Date
* Total Cases
* New Cases
* Total Deaths
* New Deaths
* Continent
* Population

---

- <a href="https://github.com/YTFarhan/COVID-19_Data_Analysis/blob/main/CovidVaccinations.xlsx">CovidVaccinations</a>

Contains:

* Location
* Date
* Vaccination-related columns

---

### Why Separate the Tables?

* To simulate real-world relational database structure
* To demonstrate SQL JOIN operations
* To progress from basic aggregation queries → to more advanced relational analysis
* To show understanding of database design principles

---

## SQL Analysis (Microsoft SQL Server)


### 1️⃣ Global Totals & Death Percentage

```sql
Select SUM(new_cases) as total_cases,
       SUM(cast(new_deaths as int)) as total_deaths,
       SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2
```

🔎 **Insight:**
Calculated total global cases, total deaths, and overall death rate.

---

### 2️⃣ Total Deaths by Continent

```sql
Select location,
       SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc
```

🔎 **Insight:**
Filtered out aggregate regions to isolate continent-level analysis.

---

### 3️⃣ Countries with Highest Infection Rate

```sql
Select Location,
       Population,
       MAX(total_cases) as HighestInfectionCount,
       Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc
```

🔎 **Insight:**
Identified countries with the highest infection percentage relative to population.

---

### 4️⃣ Infection Rate Over Time

```sql
Select Location,
       Population,
       date,
       MAX(total_cases) as HighestInfectionCount,
       Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc
```

🔎 **Insight:**
Analyzed how infection percentages evolved month-by-month.

---

## Tableau Dashboard Features

The dashboard includes:

### 🌍 Global KPIs

* Total Cases
* Total Deaths
* Death Percentage

### 🗺 Map Visualization

* Percent population infected by country
* Color gradient for quick geographic comparison

### 📊 Total Deaths by Continent

* Clear comparative bar chart

### 📈 Time Series Analysis

* Percent population infected over time
* Actual vs Forecast projections
* Multi-country comparison (US, UK, Canada, Russia, China)

<img width="2092" height="1121" alt="Screenshot 2026-03-22 122154" src="https://github.com/user-attachments/assets/cacb7716-95dc-4ce4-a8e5-f8850ae424a7" />

---

## 📈 Key Insights

* Europe and North America had the highest death counts.
* The United States and United Kingdom experienced sharp infection growth in late 2020.
* Some countries had high infection percentages despite smaller populations.
* Forecast modeling shows continued upward infection trends in major countries.

---

## 🎯 What This Project Demonstrates

✔ Data cleaning & transformation
✔ Relational database thinking
✔ SQL aggregations & grouping
✔ Filtering & data integrity validation
✔ Percent calculations & rate metrics
✔ Data storytelling
✔ Professional dashboard design
✔ Business-focused KPIs

---

## 🚀 Why This Matters

This project reflects how real analysts:

* Clean messy datasets
* Design relational tables
* Write analytical SQL queries
* Extract meaningful insights
* Build executive-ready dashboards
