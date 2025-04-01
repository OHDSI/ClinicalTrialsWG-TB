WITH op_dates AS (
    SELECT
        usubjid
        , MIN(dsstdy) AS min_dsstdy
        , MAX(dsstdy) AS max_dsstdy
    FROM {{ ref('stg_sdtm__ds') }}
    GROUP BY usubjid
)

SELECT
    ROW_NUMBER() OVER (ORDER BY per.person_id) AS observation_period_id
    , per.person_id
    , {{ dateadd(datepart="day", interval="od.min_dsstdy", from_date_or_timestamp="'2014-10-23'") }} AS observation_period_start_date
    , {{ dateadd(datepart="day", interval="od.max_dsstdy", from_date_or_timestamp="'2014-10-23'") }} AS observation_period_end_date
    , 32809 AS period_type_concept_id  -- 'Case Report Form'
FROM op_dates AS od
INNER JOIN {{ ref('int__person') }} AS per
    ON od.usubjid = per.person_source_value
