-------------------------------------------------------------------
-- Copyright 2024 Observational Health Data Sciences and Informatics
-- Clinical Trials Workgroup
-------------------------------------------------------------------
TRUNCATE TABLE cdm.location;

INSERT INTO cdm.location
SELECT
    ROW_NUMBER() OVER ()                        AS location_id,
    NULL                                        AS address_1,
    NULL                                        AS address_2,
    NULL                                        AS city,
    NULL                                        AS state,
    NULL                                        AS zip,
    NULL                                        AS county,
    src.country                                 AS location_source_value,
    CASE
        WHEN src.country = 'ZAF' THEN 4073743
        WHEN src.country = 'TZA' THEN 4072112 
        WHEN src.country = 'UGA' THEN 4071840
        ELSE 0
    END                                         AS country_concept_id,
    CASE
        WHEN src.country = 'ZAF' THEN 'South Africa'
        WHEN src.country = 'TZA' THEN 'Tanzania'
        WHEN src.country = 'UGA' THEN 'Uganda'
        ELSE NULL
    END                                         AS country_source_value,
    CASE
        WHEN src.country = 'ZAF' THEN 30.5595
        WHEN src.country = 'TZA' THEN 6.3690
        WHEN src.country = 'UGA' THEN 1.3733
        ELSE NULL
    END                                         AS latitude,
    CASE
        WHEN src.country = 'ZAF' THEN 22.9375
        WHEN src.country = 'TZA' THEN 34.8888
        WHEN src.country = 'UGA' THEN 32.2903
        ELSE NULL
    END                                         AS longitude,
    'location.dm'                               AS rule_id,
    src.src_tbl                                 AS src_tbl,
    NULL                                        AS src_row
FROM src.dm src
GROUP BY
    src.country,
    src.src_tbl;