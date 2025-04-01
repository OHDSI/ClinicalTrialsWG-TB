{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sdtm', 'dm') ) 
%}


WITH cte_dm_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sdtm','dm') }}
)

, cte_dm_rename AS (
-- TODO: rename columns to be human readable
    SELECT *
    FROM cte_dm_lower
)

SELECT *
FROM cte_dm_rename
