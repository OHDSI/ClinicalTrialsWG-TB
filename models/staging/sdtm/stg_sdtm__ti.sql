{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sdtm', 'ti') ) 
%}


WITH cte_ti_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sdtm','ti') }}
)

, cte_ti_rename AS (
-- TODO: rename columns to be human readable
    SELECT *
    FROM cte_ti_lower
)

SELECT *
FROM cte_ti_rename
