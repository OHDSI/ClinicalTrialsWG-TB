SELECT
    ROW_NUMBER() OVER (ORDER BY per.person_id, sv.visitnum) AS visit_occurrence_id
    , per.person_id
    , 581477 AS visit_concept_id  -- 'Office visit'
    , {{ dateadd(datepart="day", interval="sv.svstdy", from_date_or_timestamp="'2014-10-23'") }} AS visit_start_date
    , {{ dateadd(datepart="day", interval="sv.svendy", from_date_or_timestamp="'2014-10-23'") }} AS visit_end_date
    , 32809 AS visit_type_concept_id -- 'Case Report Form'
    , {{ dbt.concat(["per.person_source_value", "' | '", "sv.visitnum"]) }} AS visit_source_value
FROM {{ ref('stg_sdtm__sv') }} AS sv
LEFT JOIN {{ ref('int__person') }} AS per
    ON sv.usubjid = per.person_source_value
WHERE
    sv.svstdy IS NOT NULL
    AND sv.svendy IS NOT NULL
