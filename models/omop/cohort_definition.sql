SELECT
    cohort_definition_id
    , cohort_definition_name
    , cohort_definition_description
    , 0 AS cohort_definition_type_concept_id
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS cohort_definition_syntax
    , 1147314 AS subject_concept_id -- Person domain
    , {{ dbt.cast(dbt.current_timestamp(), api.Column.translate_type("date")) }} AS cohort_initiation_date
FROM {{ ref('int__cohort_definition') }}
