
## This is a small SQL project I built to practice working with real-world style datasets.
The data I used is about COVID cases, deaths, population, and vaccinations.
The goal was to explore the numbers and try out different SQL techniques like filtering, grouping, joins, CTEs, window functions, and temp tables.


Queries comparing total cases vs total deaths and calculating death percentages.
Cases vs population, how much of each country’s population got infected.
Countries with the highest infection rates and highest death rates relative to population.
Global daily numbers for new cases and deaths.
Joining the deaths table with the vaccinations table.

Using SUM() OVER (PARTITION BY..  ORDER BY..) to build cumulative vaccination counts.
Calculating percentage of population vaccinated over time.

I ran the same vaccination percentage query in three ways:
1. CTE (Common Table Expression).
2. Nested subquery.
3. Temp table.

This was just a practice project to get more comfortable with SQL.
The difference between GROUP BY and window functions.
How to use CTEs vs subqueries.
When temp tables can be useful.
How to calculate meaningful metrics from raw data.
