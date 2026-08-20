{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sdtm', 'tv') ) 
%}


WITH cte_tv_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sdtm','tv') }}
)

, cte_tv_rename AS (
-- TODO: rename columns to be human readable
    SELECT *
    FROM cte_tv_lower
)

SELECT *
FROM cte_tv_rename
WHERE studyid = 'TB-1015'
