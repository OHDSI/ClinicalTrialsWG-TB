{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sdtm', 'ta') ) 
%}


WITH cte_ta_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sdtm','ta') }}
)

, cte_ta_rename AS (
-- TODO: rename columns to be human readable
    SELECT *
    FROM cte_ta_lower
)

SELECT *
FROM cte_ta_rename
WHERE studyid = 'TB-1015'
