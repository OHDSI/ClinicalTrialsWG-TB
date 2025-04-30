WITH sites AS (
    SELECT DISTINCT
        siteid
        , country
    FROM {{ ref('stg_sdtm__dm') }}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY sites.siteid) AS care_site_id
    , loc.location_id
    , sites.siteid AS care_site_source_value
FROM sites
LEFT JOIN {{ ref('int__location') }} AS loc
    ON sites.country = loc.location_source_value
