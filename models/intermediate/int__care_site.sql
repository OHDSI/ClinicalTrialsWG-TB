WITH sites AS (
    SELECT DISTINCT
        siteid
        , country
    FROM {{ ref('stg_sdtm__dm') }}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY sites.siteid) AS care_site_id
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS care_site_name
    , 0 AS place_of_service_concept_id
    , loc.location_id
    , sites.siteid AS care_site_source_value
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS place_of_service_source_value
FROM sites
LEFT JOIN {{ ref('int__location') }} AS loc
    ON sites.country = loc.location_source_value
