SELECT
    visit_occurrence_id
    , person_id
    , visit_concept_id
    , visit_start_date
    , {{ dbt.cast("NULL", api.Column.translate_type("datetime")) }} AS visit_start_datetime
    , visit_end_date
    , {{ dbt.cast("NULL", api.Column.translate_type("datetime")) }} AS visit_end_datetime
    , visit_type_concept_id
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS provider_id
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS care_site_id
    , visit_source_value
    , 0 AS visit_source_concept_id
    , 0 AS admitted_from_concept_id
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS admitted_from_source_value
    , 0 AS discharged_to_concept_id
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS discharged_to_source_value
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS preceding_visit_occurrence_id
FROM {{ ref('int__visit_occurrence') }}
