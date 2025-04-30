WITH countries AS (
    SELECT DISTINCT country
    FROM {{ ref('stg_sdtm__dm') }}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY country) AS location_id
    , country AS location_source_value
    , CASE
        WHEN country = 'ZAF' THEN 4073743
        WHEN country = 'TZA' THEN 4072112
        WHEN country = 'UGA' THEN 4071840
        ELSE 0
    END AS country_concept_id
    , CASE
        WHEN country = 'ZAF' THEN 'South Africa'
        WHEN country = 'TZA' THEN 'Tanzania'
        WHEN country = 'UGA' THEN 'Uganda'
    END AS country_source_value
    , CASE
        WHEN country = 'ZAF' THEN 30.5595
        WHEN country = 'TZA' THEN 6.3690
        WHEN country = 'UGA' THEN 1.3733
    END AS latitude
    , CASE
        WHEN country = 'ZAF' THEN 22.9375
        WHEN country = 'TZA' THEN 34.8888
        WHEN country = 'UGA' THEN 32.2903
    END AS longitude
FROM countries
