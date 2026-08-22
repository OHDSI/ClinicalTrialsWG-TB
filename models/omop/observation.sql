SELECT
    observation_id
    , person_id
    , observation_concept_id
    , observation_date
    , {{ dbt.cast("NULL", api.Column.translate_type("timestamp")) }} AS observation_datetime
    , 32809 AS observation_type_concept_id  -- Case report form
    , {{ dbt.cast("NULL", api.Column.translate_type("float")) }} AS value_as_number
    , value_as_string
    , value_as_concept_id
    , qualifier_concept_id
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS unit_concept_id
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS provider_id
    , visit_occurrence_id
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS visit_detail_id
    , observation_source_value
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS observation_source_concept_id
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS unit_source_value
    , qualifier_source_value
    , value_source_value
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS observation_event_id
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS obs_event_field_concept_id
FROM {{ ref('int__observation') }}
