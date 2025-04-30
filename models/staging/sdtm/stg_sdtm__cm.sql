{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sdtm', 'cm') ) 
%}


WITH cte_cm_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sdtm','cm') }}
)

, cte_cm_rename AS (
-- TODO: rename columns to be human readable
    SELECT
        id
        , studyid
        , "domain"
        , usubjid
        , cmseq
        , cmgrpid
        , cmspid
        , cmlnkid
        , cmtrt
        , cmmodify
        , cmdecod
        , cmcat
        , cmscat
        , cmpresp
        , cmoccur
        , cmstat
        , cmreasnd
        , cmindc
        , cmclas
        , cmdose
        , cmdosu
        , cmdosfrm
        , cmdosfrq
        , cmdostot
        , cmdosrgm
        , cmroute
        , cmpstrg
        , cmpstrgu
        , cmadj
        , CASE
            WHEN visitnum = 'NA' THEN NULL
            ELSE {{ dbt.cast("visitnum", api.Column.translate_type("integer")) }}
        END AS visitnum
        , visit
        , epoch
        , cmdy
        , CASE
            WHEN cmstdy = 'NA' THEN NULL
            ELSE {{ dbt.cast("cmstdy", api.Column.translate_type("integer")) }}
        END AS cmstdy
        , CASE
            WHEN cmendy = 'NA' THEN NULL
            ELSE {{ dbt.cast("cmendy", api.Column.translate_type("integer")) }}
        END AS cmendy
        , cmdur
        , cmstrf
        , cmenrf
        , cmevintx
        , cmstrtpt
        , cmsttpt
        , cmenrtpt
        , cmentpt
        , ststudmo
        , enstudmo
        , ststudyr
        , enstudyr
        , cmact1
        , cmact2
        , cmact3
        , cmact4
        , cmact5
        , cmact6
        , cmact7
        , cmact8
        , aeacn
        , aerel
        , cmarvn
        , cmarvs
        , cmarvy
        , atccd10
        , atccd1
        , atccd2
        , atccd3
        , atccd4
        , atccd5
        , atccd6
        , atccd7
        , atccd8
        , atccd9
        , atctext
        , basename
        , cmdostxt
        , cmdurunk
        , saltname
        , whocode
        , whoname
        , {{ dbt.concat(["cmtrt","'|'","cmdose","'|'","cmdosu","'|'","cmroute"]) }} AS cm_concat
    FROM cte_cm_lower
)

SELECT *
FROM cte_cm_rename
