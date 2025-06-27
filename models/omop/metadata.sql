WITH cte_ti_ts AS (
    SELECT
        'TI' AS source_table
        , 0 AS metadata_concept_id
        , 0 AS metadata_type_concept_id
        , tsparm AS {{ adapter.quote("name") }}
        , tsval AS value_as_string
        , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS value_as_concept_id
        , {{ dbt.cast("NULL", api.Column.translate_type("date")) }} AS metadata_date
        , {{ dbt.cast("NULL", api.Column.translate_type("timestamp")) }} AS metadata_datetime
    FROM {{ ref('stg_sdtm__ts') }}
    WHERE tsval IS NOT NULL

    UNION ALL

    SELECT
        'TS' AS source_table
        , 0 AS metadata_concept_id
        , 0 AS metadata_type_concept_id
        , ietestcd AS {{ adapter.quote("name") }}
        , ietest AS value_as_string
        , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS value_as_concept_id
        , {{ dbt.cast("NULL", api.Column.translate_type("date")) }} AS metadata_date
        , {{ dbt.cast("NULL", api.Column.translate_type("timestamp")) }} AS metadata_datetime
    FROM {{ ref('stg_sdtm__ti') }}
    WHERE ietest IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY name) AS metadata_id
    , metadata_concept_id
    , metadata_type_concept_id
    , name
    , value_as_string
    , value_as_concept_id
    , metadata_date
    , metadata_datetime
FROM cte_ti_ts
