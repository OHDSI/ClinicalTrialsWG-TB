{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sdtm', 'te') ) 
%}


WITH cte_te_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sdtm','te') }}
)

, cte_te_rename AS (
-- TODO: rename columns to be human readable
    SELECT *
    FROM cte_te_lower
)

SELECT *
FROM cte_te_rename
WHERE studyid = 'TB-1015'
