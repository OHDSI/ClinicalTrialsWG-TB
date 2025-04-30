SELECT
    care_site_id
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS care_site_name
    , 0 AS place_of_service_concept_id
    , location_id
    , care_site_source_value
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS place_of_service_source_value
FROM {{ ref("int__care_site")}}
