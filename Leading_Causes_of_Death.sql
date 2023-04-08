-- I wanted to clean up the data, so I used an update and case statement to change the names so it wouldnt show the names of race seperately as their were two different names for same races
UPDATE Nyc_data.death
SET `Race Ethnicity` = 
  CASE 
    WHEN `Race Ethnicity` = 'Non-Hispanic White' THEN 'White Non-Hispanic'
    WHEN `Race Ethnicity` = 'Non-Hispanic Black' THEN 'Black Non-Hispanic'
    ELSE `Race Ethnicity`
  END
WHERE `Race Ethnicity` IN ('Non-Hispanic White', 'Non-Hispanic Black');


-- Here I am updaing and cleaning the data because male and female entries were in two different formarts, I decided to change them to one single so that all entries for male and female would show and display correct data
UPDATE Nyc_data.death 
SET 
    Sex = CASE
        WHEN Sex = 'M' THEN 'Male'
        WHEN Sex = 'F' THEN 'Female'
        ELSE Sex
    END;
    
    
-- Total deaths for each indiviual ethnicity    
SELECT 
    `Race Ethnicity`, SUM(Deaths) AS TotalDeaths
FROM
    Nyc_data.death
GROUP BY `Race Ethnicity`
ORDER BY TotalDeaths DESC;

 
-- Total deaths based on the persons gender
SELECT 
    Sex, SUM(Deaths)
FROM
    Nyc_data.death
GROUP BY Sex;


-- Total deaths based on the persons gender, but instead by each year from 2007 through 2019
SELECT 
    `Year`, Sex, SUM(Deaths) AS total_deaths
FROM
    Nyc_data.death
WHERE
    Year BETWEEN 2007 AND 2019
GROUP BY `Year` , Sex
ORDER BY `Year` , Sex;


-- Average deaths based on the persons gender, but instead by each year from 2007 through 2019
SELECT 
    `Year`, Sex, ROUND(AVG(Deaths),1) AS average_deaths
FROM
    Nyc_data.death
WHERE
    Year BETWEEN 2007 AND 2019
GROUP BY `Year` , Sex
ORDER BY `Year` , Sex;

-- Total deaths based on a leading cause 
SELECT 
    `Leading Cause`, SUM(Deaths) AS TotalDeaths
FROM
    Nyc_data.death
GROUP BY `Leading Cause`
ORDER BY TotalDeaths DESC;


-- Total deaths per year based on Leading Cause 
SELECT 
    `Year`, SUM(Deaths) AS TotalDeaths, `Leading Cause`
FROM
    Nyc_data.death
GROUP BY `Year` , `Leading Cause`
ORDER BY TotalDeaths DESC;


-- Slightly difficult query to understand, lets break it down! The query goes builds from the inner most query all the way to the outermost.
-- What this means is the inner most query runs first all the way to the outer query written.
-- Overall, this query is identifying the leading causes of death in each year and their corresponding death count
SELECT DISTINCT
    `Year`, `Leading Cause`, TotalDeaths
FROM
    (SELECT 
        `Year`, `Leading Cause`, SUM(`Deaths`) AS TotalDeaths
    FROM
        Nyc_data.death
    GROUP BY `Year` , `Leading Cause`
    ORDER BY TotalDeaths DESC) AS YearCauseDeaths
WHERE
    (`Year` , TotalDeaths) IN (SELECT 
            `Year`, MAX(`TotalDeaths`)
        FROM
            (SELECT 
                `Year`, `Leading Cause`, SUM(`Deaths`) AS TotalDeaths
            FROM
                Nyc_data.death
            GROUP BY `Year` , `Leading Cause`) AS YearCauseDeaths
        GROUP BY `Year`);


-- This shows the leading causes of death for feamles and the corresponding total death count
SELECT 
    Sex, SUM(Deaths) as total_deaths, `Leading Cause`
FROM
    Nyc_data.death
WHERE
    Sex = 'Female'
GROUP BY Sex , `Leading Cause`
ORDER BY SUM(Deaths) DESC;
 
 
-- Shows the average death for each ethnicity and the leading cause of death 
SELECT 
    ROUND(AVG(Deaths), 2) AS average_deaths,
    `Race Ethnicity`,
    `Leading Cause`
FROM
    Nyc_data.death
GROUP BY `Race Ethnicity` , `Leading Cause`
ORDER BY average_deaths DESC;


-- Dsiplays the average death rate for each race listed 
-- The average death rate from the data is the number of deaths per 100,000 people
SELECT 
    `Race Ethnicity`,
    ROUND(AVG(`Death Rate`), 2) AS average_death_rate
FROM
    Nyc_data.death
GROUP BY `Race Ethnicity`
ORDER BY average_death_rate DESC;


-- Lastly, I was curious as many of the deaths were due to cancer or diseases of the heart, but I wanted to know which ethnicities were dying due to other factors
-- The factors that I wanted todive into were assault and alcohol 
SELECT 
    `Race Ethnicity`, SUM(`Deaths`) AS deaths
FROM
    Nyc_data.death
WHERE
    `Leading Cause` IN ('Assault (Homicide: Y87.1, X85-Y09)' , 'Mental and Behavioral Disorders due to Use of Alcohol (F10)')
GROUP BY `Race Ethnicity`
ORDER BY deaths DESC



