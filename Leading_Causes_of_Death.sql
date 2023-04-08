
UPDATE Nyc_data.death
SET `Race Ethnicity` = 
  CASE 
    WHEN `Race Ethnicity` = 'Non-Hispanic White' THEN 'White Non-Hispanic'
    WHEN `Race Ethnicity` = 'Non-Hispanic Black' THEN 'Black Non-Hispanic'
    ELSE `Race Ethnicity`
  END
WHERE `Race Ethnicity` IN ('Non-Hispanic White', 'Non-Hispanic Black');


SELECT `Race Ethnicity`, SUM(Deaths) as TotalDeaths
FROM Nyc_data.death
GROUP BY `Race Ethnicity`
ORDER BY TotalDeaths DESC;


SELECT Sex , SUM(Deaths)
FROM Nyc_data.death
GROUP BY Sex;

UPDATE Nyc_data.death
SET Sex =
CASE 
WHEN Sex = 'M' THEN 'Male'
WHEN Sex = 'F' THEN 'Female'
ELSE Sex
END;

SELECT `Leading Cause`, SUM(Deaths) as TotalDeaths
FROM Nyc_data.death
GROUP BY `Leading Cause`
ORDER BY TotalDeaths DESC;

SELECT  `Year`, SUM(Deaths) as TotalDeaths, `Leading Cause`
FROM Nyc_data.death
GROUP BY `Year`,`Leading Cause`
ORDER BY TotalDeaths DESC;


SELECT DISTINCT `Year`, `Leading Cause`,TotalDeaths
FROM (
  SELECT `Year`, `Leading Cause`, SUM(`Deaths`) AS TotalDeaths
  FROM Nyc_data.death
  GROUP BY `Year`, `Leading Cause`
  ORDER BY TotalDeaths DESC 
) AS YearCauseDeaths
WHERE ( `Year`, TotalDeaths ) IN (
  SELECT `Year`, MAX(`TotalDeaths`)
  FROM (
    SELECT `Year`, `Leading Cause`, SUM(`Deaths`) AS TotalDeaths
    FROM Nyc_data.death
    GROUP BY `Year`, `Leading Cause`
  ) AS YearCauseDeaths
  GROUP BY `Year`
);

SELECT `Leading Cause`, ROUND(MAX(`Age Adjusted Death Rate`),2) as max_age_rate
FROM Nyc_data.death
WHERE `Age Adjusted Death Rate` != '.'
GROUP BY `Leading Cause`
HAVING MAX(`Age Adjusted Death Rate`)
ORDER BY max_age_rate DESC ;


SELECT Sex, SUM(Deaths), `Leading Cause`
FROM Nyc_data.death
WHERE Sex = 'Female'
GROUP BY Sex, `Leading Cause`
ORDER BY SUM(Deaths) DESC;
 
 
SELECT ROUND(AVG(Deaths),2) AS average_deaths, `Race Ethnicity`, `Leading Cause`
FROM Nyc_data.death
GROUP BY `Race Ethnicity`,`Leading Cause`
ORDER BY average_deaths DESC;

SELECT `Race Ethnicity`, ROUND(AVG(`Death Rate`),2) as average_death_rate
FROM Nyc_data.death
GROUP BY `Race Ethnicity`
ORDER BY average_death_rate DESC;

SELECT `Race Ethnicity`, ROUND(AVG(`Age Adjusted Death Rate`),2) as age_average_death_rate
FROM Nyc_data.death
GROUP BY `Race Ethnicity`
ORDER BY age_average_death_rate DESC




