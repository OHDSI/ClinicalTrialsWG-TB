SELECT
    ROW_NUMBER() OVER (ORDER BY per.person_id, sv.visitnum) AS visit_occurrence_id
    , per.person_id
    , 581477 AS visit_concept_id  -- 'Office visit'
    , {{ dateadd(datepart="day", interval="sv.svstdy", from_date_or_timestamp="'2014-10-23'") }} AS visit_start_date
    , {{ dbt.cast("NULL", api.Column.translate_type("datetime")) }} AS visit_start_datetime
    , {{ dateadd(datepart="day", interval="sv.svendy", from_date_or_timestamp="'2014-10-23'") }} AS visit_end_date
    , {{ dbt.cast("NULL", api.Column.translate_type("datetime")) }} AS visit_end_datetime
    , 32809 AS visit_type_concept_id -- 'Case Report Form'
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS provider_id
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS care_site_id
    , {{ dbt.concat(["per.person_source_value", "' | '", "sv.visitnum"]) }} AS visit_source_value
    , 0 AS visit_source_concept_id
    , 0 AS admitted_from_concept_id
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS admitted_from_source_value
    , 0 AS discharged_to_concept_id
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS discharged_to_source_value
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS preceding_visit_occurrence_id
FROM {{ ref('stg_sdtm__sv') }} AS sv
LEFT JOIN {{ ref('int__person') }} AS per
    ON sv.usubjid = per.person_source_value
WHERE
    sv.svstdy IS NOT NULL
    AND sv.svendy IS NOT NULL
