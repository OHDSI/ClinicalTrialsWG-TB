WITH cte_ti_ts AS (
    SELECT
        'TS' AS source_table
        , 0 AS metadata_concept_id
        , 0 AS metadata_type_concept_id
        , tsparm AS {{ adapter.quote("name") }}
        , CASE
            WHEN tsgrpid IS NULL THEN tsval
            ELSE {{ dbt.concat(["tsgrpid", "' - '", "tsval"]) }}
        END AS value_as_string
        , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS value_as_concept_id
        , {{ dbt.cast("NULL", api.Column.translate_type("date")) }} AS metadata_date
        , {{ dbt.cast("NULL", api.Column.translate_type("timestamp")) }} AS metadata_datetime
    FROM {{ ref('stg_sdtm__ts') }}
    WHERE tsval IS NOT NULL

    UNION ALL

    SELECT
        'TI' AS source_table
        , 0 AS metadata_concept_id
        , 0 AS metadata_type_concept_id
        , ietestcd AS {{ adapter.quote("name") }}
        , ietest AS value_as_string
        , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS value_as_concept_id
        , {{ dbt.cast("NULL", api.Column.translate_type("date")) }} AS metadata_date
        , {{ dbt.cast("NULL", api.Column.translate_type("timestamp")) }} AS metadata_datetime
    FROM {{ ref('stg_sdtm__ti') }}
    WHERE ietest IS NOT NULL

    UNION ALL

    SELECT
        'TV' AS source_table
        , 0 AS metadata_concept_id
        , 0 AS metadata_type_concept_id
        , {{ dbt.concat(["'Visit '", "visitnum", "' | '", "visit"]) }} AS {{ adapter.quote("name") }}
        , tvstrl AS value_as_string
        , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS value_as_concept_id
        , {{ dbt.cast("NULL", api.Column.translate_type("date")) }} AS metadata_date
        , {{ dbt.cast("NULL", api.Column.translate_type("timestamp")) }} AS metadata_datetime
    FROM {{ ref('stg_sdtm__tv') }}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY name) AS metadata_id
    , metadata_concept_id
    , metadata_type_concept_id
    , {{ adapter.quote("name") }}
    , value_as_string
    , value_as_concept_id
    , metadata_date
    , metadata_datetime
FROM cte_ti_ts
