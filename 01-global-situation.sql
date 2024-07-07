/* GLOBAL SITUATION */
SELECT country_name, year, forest_area_sqkm
FROM forestation
WHERE year = 1990 AND country_name = 'World';
-- country_name	    year	forest_area_sqkm
-- World	        1990	41282694.9

SELECT country_name, year, forest_area_sqkm
FROM forestation
WHERE year = 2016 AND country_name = 'World';
-- country_name	    year	forest_area_sqkm
-- World	        2016	39958245.9

SELECT (t2016.forest_area_sqkm - t1990.forest_area_sqkm) AS change_forest_sqkm
FROM forestation AS t2016, forestation AS t1990
WHERE t2016.year = '2016' AND t2016.country_name = 'World'
AND   t1990.year = '1990' AND t1990.country_name = 'World';
-- change_forest_sqkm
-- -1324449

SELECT (1-(t1990.forest_area_sqkm / t2016.forest_area_sqkm))*100 AS percent_change_forest_sqkm
FROM forestation AS t2016, forestation AS t1990
WHERE t2016.year = '2016' AND t2016.country_name = 'World'
AND   t1990.year = '1990' AND t1990.country_name = 'World';
-- percent_change_forest_sqkm
-- -3.314582435161406

WITH area_2016 AS (
    SELECT country_name, (total_area_sq_mi * 2.59) AS total_area_sqkm
    FROM forestation
    WHERE year = '2016'
),
forest_loss_sqkm AS (
    SELECT (t2016.forest_area_sqkm - t1990.forest_area_sqkm) AS change_forest_sqkm
    FROM forestation AS t2016, forestation AS t1990
    WHERE t2016.year = '2016' AND t2016.country_name = 'World'
    AND t1990.year = '1990' AND t1990.country_name = 'World'
)
SELECT country_name, total_area_sqkm, change_forest_sqkm
FROM area_2016, forest_loss_sqkm
ORDER BY ABS(-total_area_sqkm - change_forest_sqkm)
LIMIT 1;
-- country_name	total_area_sqkm	change_forest_sqkm
-- Peru	1279999.9891	-1324449