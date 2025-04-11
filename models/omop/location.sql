SELECT
    location_id
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS address_1
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS address_2
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS city
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS state
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS zip
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS county
    , location_source_value
    , country_concept_id
    , country_source_value
    , latitude
    , longitude
FROM {{ ref('int__location') }}
