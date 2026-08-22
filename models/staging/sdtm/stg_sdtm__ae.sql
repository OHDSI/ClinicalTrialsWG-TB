{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sdtm', 'ae') ) 
%}


WITH cte_ae_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sdtm','ae') }}
)

, cte_ae_rename AS (
-- TODO: rename columns to be human readable
    SELECT
        id
        , studyid
        , domain
        , usubjid
        , aeseq
        , aerefid
        , aespid
        , aelnkid
        , aeterm
        , aemodify
        , aellt
        , aedecod
        , aehlt
        , aehlgt
        , aecat
        , aescat
        , aebodsys
        , aesoc
        , aesev
        , aeser
        , aeacnoth
        , aerel
        , aerelnst
        , aepatt
        , aeout
        , aescong
        , aesdisab
        , aesdth
        , aeshosp
        , aeslife
        , aesod
        , aesmie
        , aecontrt
        , aetoxgr
        , CASE
            WHEN visitnum = 'NA' THEN NULL
            ELSE {{ dbt.cast("visitnum", api.Column.translate_type("integer")) }}
        END AS visitnum
        , visit
        , epoch
        , aedy
        , CASE
            WHEN aestdy = 'NA' THEN NULL
            ELSE {{ dbt.cast("aestdy", api.Column.translate_type("integer")) }}
        END AS aestdy
        , CASE
            WHEN aeendy = 'NA' THEN NULL
            ELSE {{ dbt.cast("aeendy", api.Column.translate_type("integer")) }}
        END AS aeendy
        , aedur
        , aeenrf
        , aeentpt
        , ststudmo
        , enstudmo
        , ststudyr
        , enstudyr
        , aeacn
        , aeacnbpa
        , acncomm
        , aeacnlzd
        , autopsy
        , caus1
        , caus1hlt
        , caus1llt
        , caus1pt
        , caus1soc
        , caus1sp
        , caus2
        , caus2hlt
        , caus2llt
        , caus2pt
        , caus2soc
        , caus2sp
        , caus3
        , caus3sp
        , caus4
        , caus4hlt
        , caus4llt
        , caus4pt
        , caus4soc
        , caus4sp
        , caus5
        , caus5hlt
        , caus5llt
        , caus5pt
        , caus5soc
        , caus5sp
        , caus6
        , caus6hlt
        , caus6llt
        , caus6pt
        , caus6soc
        , caus6sp
        , aechange
        , cmsusae1
        , concomae
        , conmed1
        , conmed2
        , conmed3
        , conmed4
        , conmed5
        , conmed6
        , aediscdy
        , drugae
        , ethsusae
        , aeexdy
        , hepatfl
        , isosusae
        , aelbrslt
        , otherhlt
        , otherllt
        , otherpt
        , othersae
        , othersoc
        , period
        , aeprior
        , aeprod
        , pzasusae
        , rechalng
        , aereindy
        , aerelbdq
        , aerellzd
        , aereloth
        , aerelpmd
        , reltbmed
        , aereocur
        , rptsusae
        , aeserrpt
        , aesersp
        , trtemerg
        , withdraw
        , withdrdy
        , worsened
    FROM cte_ae_lower
)

SELECT *
FROM cte_ae_rename
