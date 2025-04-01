-------------------------------------------------------------------
-- Copyright 2024 Observational Health Data Sciences and Informatics
-- Clinical Trials Workgroup
-------------------------------------------------------------------
TRUNCATE TABLE cdm.observation_period;

INSERT INTO cdm.observation_period
SELECT
    ROW_NUMBER() OVER ()                AS observation_period_id,
    per.person_id                       AS person_id,
    CAST('2014-10-23' AS DATE)
        + CAST(MIN(src.dsstdy) AS INT)  AS observation_period_start_date,
    CAST('2014-10-23' AS DATE)
        + CAST(MAX(src.dsstdy) AS INT)  AS observation_period_end_date,
    32809                               AS period_type_concept_id,  -- 'Case Report Form'
    'obs_per.dm'                        AS rule_id,
    src.src_tbl                         AS src_tbl,
    NULL                                AS src_row
FROM
    src.ds src
INNER JOIN
    cdm.person per
        ON per.person_source_value = src.usubjid
GROUP BY
    per.person_id,
    src.src_tbl;
