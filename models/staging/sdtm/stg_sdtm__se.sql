{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sdtm', 'se') ) 
%}


WITH cte_se_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sdtm','se') }}
)

, cte_se_rename AS (
-- TODO: rename columns to be human readable
    SELECT *
    FROM cte_se_lower
)

SELECT *
FROM cte_se_rename
WHERE studyid = 'TB-1015'
