-------------------------------------------------------------------
-- Copyright 2024 Observational Health Data Sciences and Informatics
-- Clinical Trials Workgroup
-------------------------------------------------------------------
TRUNCATE TABLE cdm.visit_occurrence;

-- DROP TABLE IF EXISTS cdm.tmp_visit_occurrence;
-- -- Copy structure for staging
-- CREATE TABLE cdm.tmp_visit_occurrence AS
-- SELECT *
-- FROM cdm.visit_occurrence
-- WHERE 1 = 0
-- ;


INSERT INTO cdm.visit_occurrence
SELECT
    ROW_NUMBER() OVER ()                    AS visit_occurrence_id,
    per.person_id                           AS person_id,
    581477                                  AS visit_concept_id,  -- 'Office visit'
    CAST('2014-10-23' AS DATE)
        + CAST(src.svstdy AS INT)           AS visit_start_date,
    NULL                                    AS visit_start_datetime,
    CAST('2014-10-23' AS DATE)
        + CAST(src.svendy AS INT)           AS visit_end_date,
    NULL                                    AS visit_end_datetime,
    32809                                   AS visit_type_concept_id, -- 'Case Report Form'
    NULL                                    AS provider_id,
    NULL                                    AS care_site_id,
    'usubjid'
        || '|'
        || CAST(src.visitnum AS VARCHAR)    AS visit_source_value,
    0                                       AS visit_source_concept_id,
    0                                       AS admitted_from_concept_id,
    NULL                                    AS admitted_from_source_value,
    0                                       AS discharged_to_concept_id,
    NULL                                    AS discharged_to_source_value,
    NULL                                    AS preceding_visit_occurrence_id
FROM
    src.sv src
LEFT JOIN
    cdm.person per
        ON per.person_source_value = src.usubjid  -- add death and other constraints
WHERE src.svstdy IS NOT NULL
    AND src.svendy IS NOT NULL;


