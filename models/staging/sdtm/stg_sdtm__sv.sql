{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sdtm', 'sv') ) 
%}


WITH cte_sv_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sdtm','sv') }}
)

, cte_sv_rename AS (
-- TODO: rename columns to be human readable
    SELECT
        id
        , studyid
        , domain
        , usubjid
        , svseq
        , svspid
        , visitnum
        , visit
        , epoch
        , CASE
            WHEN svstdy = 'NA' THEN NULL
            ELSE {{ dbt.cast("svstdy", api.Column.translate_type("integer")) }}
        END AS svstdy
        , CASE
            WHEN svendy = 'NA' THEN NULL
            ELSE {{ dbt.cast("svendy", api.Column.translate_type("integer")) }}
        END AS svendy
        , dtmseen
        , encourag
        , evaltype
        , moveaway
        , newaddr
        , nolocate
        , patdied
        , patseen
        , relseen
        , timely
        , tsupseen
        , svtype
        , svupdes1
        , svupdes
        , visited
        , whynosho
    FROM cte_sv_lower

)

SELECT *
FROM cte_sv_rename
