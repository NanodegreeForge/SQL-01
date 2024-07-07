/* REGIONAL OUTLOOK */
WITH percent_forest_region AS (
    SELECT
        SUM(t1990.forest_area_sqkm) AS region_forest_1990,
        SUM(t1990.total_area_sq_mi * 2.59) AS region_area_1990,
        t1990.region,
        SUM(t2016.forest_area_sqkm) AS region_forest_2016,
        SUM(t2016.total_area_sq_mi * 2.59) AS region_area_2016
    FROM forestation t1990
    JOIN forestation t2016 ON t1990.region = t2016.region
    WHERE t1990.year = '1990' AND t2016.year = '2016'
    GROUP BY t1990.region
)
SELECT
    region,
    (region_forest_1990 / region_area_1990) * 100 AS forest_cover_1990,
    (region_forest_2016 / region_area_2016) * 100 AS forest_cover_2016
FROM percent_forest_region
ORDER BY forest_cover_1990 DESC;
-- forest_cover_1990	forest_cover_2016	region
-- 51.03	            46.16	            Latin America & Caribbean
-- 37.28	            38.04	            Europe & Central Asia
-- 35.65	            36.04	            North America
-- 32.42	            31.38	            World
-- 30.67	            28.79	            Sub-Saharan Africa
-- 25.78	            26.36	            East Asia & Pacific
-- 16.51	            17.51	            South Asia
-- 1.78	                2.07	            Middle East & North Africa