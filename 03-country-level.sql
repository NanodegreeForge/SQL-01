/* COUNTRY-LEVEL */
SELECT t2016.country_name, t2016.region,
(t2016.forest_area_sqkm - t1990.forest_area_sqkm) AS change_forest_sqkm
FROM forestation AS t2016
JOIN forestation AS t1990 ON t2016.country_code = t1990.country_code
WHERE t2016.year = '2016' AND t1990.year = '1990'
AND t2016.country_name != 'World' --- Ignore World as a country
AND t2016.forest_area_sqkm != 0 AND t1990.forest_area_sqkm != 0
ORDER BY change_forestArea_sqkm DESC
LIMIT 5;
-- country_name	region	                            change_forestarea_sqkm
-- China    	East Asia & Pacific	                527229.0619999999
-- United       States	North America	            79200
-- India    	South Asia	                        69213.98439999996
-- Russian      Federation	Europe & Central Asia	59395
-- Vietnam  	East Asia & Pacific	                55390

SELECT t2016.country_name, t2016.region,
(t2016.forest_area_sqkm - t1990.forest_area_sqkm) AS change_forest_sqkm
FROM forestation AS t2016
JOIN forestation AS t1990 ON t2016.country_code = t1990.country_code
WHERE t2016.year = '2016' AND t1990.year = '1990'
AND t2016.country_name != 'World' --- Ignore World as a country
ORDER BY change_forestArea_sqkm ASC
LIMIT 5;
-- country_name	region	                    change_forestarea_sqkm
-- Brazil	    Latin America & Caribbean	-541510
-- Indonesia    East Asia & Pacific	        -282193.98439999996
-- Myanmar	    East Asia & Pacific	        -107234.00390000001
-- Nigeria	    Sub-Saharan Africa	        -106506.00098
-- Tanzania	    Sub-Saharan Africa	        -102320


SELECT t2016.country_name, t2016.region,
(t2016.forest_area_sqkm / (t1990.forest_area_sqkm) - 1) * 100 AS percent_change_forest
FROM forestation AS t2016
JOIN forestation AS t1990 ON t2016.country_code = t1990.country_code
WHERE t2016.year = '2016' AND t1990.year = '1990'
AND t1990.forest_area_sqkm != 0 AND t2016.forest_area_sqkm != 0
ORDER BY percent_change_forestArea DESC
LIMIT 5;
-- country_name	region	                                percent_change_forestarea
-- Iceland	    Europe & Central Asia	                213.66458887002833
-- French       Polynesia	East Asia & Pacific	        181.81818181818184
-- Bahrain	    Middle East & North Africa	            177.27273528512399
-- Uruguay	    Latin America & Caribbean	            134.11130841834793
-- Dominican    Republic	Latin America & Caribbean	82.46153402714933

SELECT t2016.country_name, t2016.region,
(t2016.forest_area_sqkm / (t1990.forest_area_sqkm) - 1) * 100 AS percent_change_forest
FROM forestation AS t2016
JOIN forestation AS t1990 ON t2016.country_code = t1990.country_code
WHERE t2016.year = '2016' AND t1990.year = '1990'
AND t1990.forest_area_sqkm != 0 AND t2016.forest_area_sqkm != 0
ORDER BY percent_change_forestArea ASC
LIMIT 5;
-- country_name	region	                    percent_change_forestarea
-- Togo	        Sub-Saharan Africa	        -75.44525592700731
-- Nigeria	    Sub-Saharan Africa	        -61.79993093884182
-- Uganda	    Sub-Saharan Africa	        -59.12860347295307
-- Mauritania	Sub-Saharan Africa	        -46.74698795180723
-- Honduras	    Latin America & Caribbean	-45.034414945919366


WITH percent_forest AS (
    SELECT country_name, region,
    (forest_area_sqkm / (total_area_sq_mi * 2.59)) * 100 AS percent_forestation
    FROM forestation
    WHERE year = '2016'
    AND country_name != 'World'
    AND forest_area_sqkm != 0 AND total_area_sq_mi != 0
)
SELECT
    CASE
        WHEN percent_forestation <= 25 THEN '0-25%'
        WHEN percent_forestation > 25 AND percent_forestation <= 50 THEN '26-50%'
        WHEN percent_forestation > 50 AND percent_forestation <= 75 THEN '51-75%'
        ELSE '76-100%'
    END AS quartile,
    COUNT(*) AS num_countries
FROM percent_forest
GROUP BY quartile
ORDER BY quartile ASC;
-- quartile	num_countries
-- 0-25%	85
-- 26-50%	72
-- 51-75%	38
-- 76-100%	9


WITH percent_forest AS (
    SELECT country_name, region,
    (forest_area_sqkm / (total_area_sq_mi * 2.59)) * 100 AS percent_forestation
    FROM forestation
    WHERE year = '2016'
    AND country_name != 'World'
    AND forest_area_sqkm != 0 AND total_area_sq_mi != 0
),
quartiles AS (
    SELECT
        CASE
            WHEN percent_forestation <= 25 THEN '0-25%'
            WHEN percent_forestation > 25 AND percent_forestation <= 50 THEN '26-50%'
            WHEN percent_forestation > 50 AND percent_forestation <= 75 THEN '51-75%'
            ELSE '76-100%'
        END AS quartile,
        country_name,
        region,
        percent_forestation
    FROM percent_forest
)
SELECT country_name, region, percent_forestation
FROM quartiles
WHERE quartile = '76-100%'
ORDER BY percent_forestation DESC;
-- country_name	            region	                    percent_forestation
-- Suriname	                Latin America & Caribbean	98.2576939676578
-- Micronesia, Fed. Sts.	East Asia & Pacific	        91.85723907152479
-- Gabon	                Sub-Saharan Africa	        90.0376418700565
-- Seychelles	            Sub-Saharan Africa	        88.41113673857889
-- Palau	                East Asia & Pacific	        87.60680854912036
-- American Samoa	        East Asia & Pacific	        87.5000875000875
-- Guyana	                Latin America & Caribbean	83.90144891106817
-- Lao PDR	                East Asia & Pacific	        82.10823176408609
-- Solomon Islands	        East Asia & Pacific	        77.86351779450665