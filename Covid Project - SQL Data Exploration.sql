SELECT *
FROM coviddeaths d
JOIN covidvax v
	ON d.date = v.date
	AND d.location = v.location