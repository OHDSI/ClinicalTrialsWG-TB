{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sdtm', 'ds') ) 
%}


WITH cte_ds_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sdtm','ds') }}
)

, cte_ds_rename AS (
-- TODO: rename columns to be human readable
    SELECT
        id
        , studyid
        , domain
        , usubjid
        , dsseq
        , dsspid
        , dsterm
        , dsmodify
        , dsdecod
        , dscat
        , dsscat
        , CASE
            WHEN visitnum = 'NA' THEN NULL
            ELSE {{ dbt.cast("visitnum", api.Column.translate_type("integer")) }}
        END AS visitnum
        , visit
        , epoch
        , CASE
            WHEN dsstdy = 'NA' THEN NULL
            ELSE {{ dbt.cast("dsstdy", api.Column.translate_type("integer")) }}
        END AS dsstdy
        , dsdur
        , dstpt
        , ststudmo
        , ststudyr
        , aenum
        , deathrel
        , knwncaus
        , CASE
            WHEN livedy = 'NA' THEN NULL
            ELSE {{ dbt.cast("livedy", api.Column.translate_type("integer")) }}
        END AS livedy
        , restrtdy
        , secncaus
        , tbwas
        , thircaus
        , CASE
            WHEN totcldur = 'NA' THEN NULL
            ELSE {{ dbt.cast("totcldur", api.Column.translate_type("integer")) }}
        END AS totcldur
        , totdscpt
        , totidose
        , trtgap
    FROM cte_ds_lower

)

SELECT *
FROM cte_ds_rename
