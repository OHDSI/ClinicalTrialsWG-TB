SELECT DISTINCT
    ds.usubjid
    , ds.dsstdy AS event_stdy
    , ds.visitnum
    , COALESCE(stcm.concept_id, 0) AS observation_concept_id
    , {{ dbt.concat(["ds.dscat", "' - '", "ds.dsdecod", "' | '", "ds.dsterm"]) }} AS observation_source_value
    , stcm.value_as_concept_id
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS value_as_string
    , CASE
        WHEN stcm.value_as_concept_id IS NOT NULL THEN {{ dbt.concat(["ds.dscat", "' - '", "ds.dsdecod", "' | '", "ds.dsterm"]) }}
        ELSE {{ dbt.cast("NULL", api.Column.translate_type("string")) }}
    END AS value_source_value
FROM {{ ref('stg_sdtm__ds') }} AS ds
LEFT JOIN {{ ref('stg_stcm__disposition') }} AS stcm
    ON stcm.status = {{ dbt.concat(["ds.dscat", "' - '", "ds.dsdecod"]) }}
