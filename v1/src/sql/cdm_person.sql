-------------------------------------------------------------------
-- Copyright 2024 Observational Health Data Sciences and Informatics
-- Clinical Trials Workgroup
-------------------------------------------------------------------
TRUNCATE TABLE cdm.person;

INSERT INTO cdm.person
SELECT
    ROW_NUMBER() OVER ()                AS person_id,
    CASE 
        WHEN src.sex = 'M' THEN 8507
        WHEN src.sex = 'F' THEN 8532
        ELSE 0
    END                                 AS gender_concept_id,
    CAST(EXTRACT(YEAR FROM CAST('2014-10-23' AS DATE)) AS INT)
        - CAST(src.age AS INT)          AS year_of_birth,
    NULL                                AS month_of_birth,
    NULL                                AS day_of_birth,
    NULL                                AS birth_datetime,
    CASE
        WHEN src.race = 'BLACK OR AFRICAN AMERICAN' THEN 8516
        WHEN src.race = 'WHITE' THEN 8527
        WHEN src.race = 'NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER' THEN 8557
        ELSE 0
    END                                 AS race_concept_id,
    CASE
        WHEN src.ethnic = 'NOT HISPANIC OR LATINO' THEN 38003564
        ELSE 0
    END                                 AS ethnicity_concept_id,
    loc.location_id                     AS location_id,
    NULL                                AS provider_id,
    cs.care_site_id                     AS care_site_id,
    src.usubjid                         AS person_source_value,
    src.sex                             AS gender_source_value,
    0                                   AS gender_source_concept_id,
    src.race                            AS race_source_value,
    0                                   AS race_source_concept_id,
    src.ethnic                          AS ethnicity_source_value,
    0                                   AS ethnicity_source_concept_id,
    'person.dm'                         AS rule_id,
    src.src_tbl                         AS src_tbl,
    src.src_row                         AS src_row
FROM
    src.dm src
LEFT JOIN
    cdm.location loc
        ON loc.location_source_value = src.country
LEFT JOIN
    cdm.care_site cs
        ON cs.care_site_source_value = src.siteid
WHERE
    src.usubjid IS NOT NULL
        AND src.age IS NOT NULL;