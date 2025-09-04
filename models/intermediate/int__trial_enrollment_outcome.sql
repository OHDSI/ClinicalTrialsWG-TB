WITH all_ds AS (
    SELECT DISTINCT
        ds.usubjid
        , ds.dsstdy AS event_stdy
        , ds.visitnum
        , COALESCE(stcm.concept_id, 0) AS observation_concept_id
        , {{ dbt.concat(["ds.dscat", "' - '", "ds.dsdecod", "' | '", "ds.dsterm"]) }} AS observation_source_value
    FROM {{ ref('stg_sdtm__ds') }} AS ds
    LEFT JOIN {{ ref('stg_stcm__trial_enrollment_outcome') }} AS stcm
        ON stcm.status = {{ dbt.concat(["ds.dscat", "' - '", "ds.dsdecod"]) }}
)

, finishers AS (
    SELECT DISTINCT
        usubjid
        , dsstdy AS event_stdy
        , visitnum
        , 40482840 AS observation_concept_id
        , {{ dbt.concat(["dscat", "' - '", "dsdecod"]) }} AS observation_source_value
    FROM {{ ref('stg_sdtm__ds') }}
    WHERE
        dscat = 'DISPOSITION EVENT'
        AND dsterm = 'COMPLETED SURVIVAL FOLLOW-UP'
)

, withdrawals AS (
    SELECT DISTINCT
        usubjid
        , dsstdy AS event_stdy
        , visitnum
        , 4087907 AS observation_concept_id
        , 'Derived status: Early withdrawal from trial' AS observation_source_value
    FROM {{ ref('stg_sdtm__ds') }}
    WHERE
        dscat = 'DISPOSITION EVENT'
        AND dsdecod != 'COMPLETED'
)

SELECT *
FROM all_ds
UNION ALL
SELECT *
FROM finishers
UNION ALL
SELECT *
FROM withdrawals
