{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sdtm', 'mh') ) 
%}


WITH cte_mh_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sdtm','mh') }}
)

, cte_mh_rename AS (
-- TODO: rename columns to be human readable
    SELECT
        id
        , studyid
        , domain
        , usubjid
        , mhseq
        , mhgrpid
        , mhspid
        , mhterm
        , mhmodify
        , mhllt
        , mhdecod
        , mhhlt
        , mhhlgt
        , mhcat
        , mhscat
        , mhpresp
        , mhoccur
        , mhstat
        , mhreasnd
        , mhbodsys
        , mhsoc
        , mhcontrt
        , mhtoxgr
        , CASE
            WHEN visitnum = 'NA' THEN NULL
            ELSE {{ dbt.cast("visitnum", api.Column.translate_type("integer")) }}
        END AS visitnum
        , visit
        , epoch
        , mhdy
        , CASE
            WHEN mhstdy = 'NA' THEN NULL
            ELSE {{ dbt.cast("mhstdy", api.Column.translate_type("integer")) }}
        END AS mhstdy
        , CASE
            WHEN mhendy = 'NA' THEN NULL
            ELSE {{ dbt.cast("mhendy", api.Column.translate_type("integer")) }}
        END AS mhendy
        , mhevintx
        , mhstrtpt
        , mhentpt
        , ststudmo
        , enstudmo
        , ststudyr
        , enstudyr
        , cataract

    FROM cte_mh_lower
)

SELECT *
FROM cte_mh_rename
