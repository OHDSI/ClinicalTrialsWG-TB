WITH op_end_date AS (
    SELECT
        usubjid
        , MAX(dsstdy) AS max_dsstdy
    FROM {{ ref('stg_sdtm__ds') }}
    GROUP BY usubjid
)

, op_start_date AS (
    SELECT
        usubjid
        , MIN(svstdy) AS min_svstdy
    FROM {{ ref('stg_sdtm__sv') }}
    GROUP BY usubjid
)



SELECT
    ROW_NUMBER() OVER (ORDER BY per.person_id) AS observation_period_id
    , per.person_id
    , {{ dateadd(datepart="day", interval="os.min_svstdy", from_date_or_timestamp="'2014-10-23'") }} AS observation_period_start_date
    , {{ dateadd(datepart="day", interval="oe.max_dsstdy", from_date_or_timestamp="'2014-10-23'") }} AS observation_period_end_date
    , 32809 AS period_type_concept_id  -- 'Case Report Form'
FROM {{ ref('int__person') }} AS per
LEFT JOIN op_start_date AS os
    ON per.person_source_value = os.usubjid
LEFT JOIN op_end_date AS oe
    ON per.person_source_value = oe.usubjid
