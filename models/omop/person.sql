SELECT
    person_id
    , gender_concept_id
    , year_of_birth
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS month_of_birth
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS day_of_birth
    , {{ dbt.cast("NULL", api.Column.translate_type("datetime")) }} AS birth_datetime
    , race_concept_id
    , ethnicity_concept_id
    , location_id
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS provider_id
    , care_site_id
    , person_source_value
    , gender_source_value
    , 0 AS gender_source_concept_id
    , race_source_value
    , 0 AS race_source_concept_id
    , ethnicity_source_value
    , 0 AS ethnicity_source_concept_id
FROM {{ ref('int__person') }}
