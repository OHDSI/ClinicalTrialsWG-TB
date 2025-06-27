{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sdtm', 'ts') ) 
%}


WITH cte_ts_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sdtm','ts') }}
)

, cte_ts_rename AS (
-- TODO: rename columns to be human readable
    SELECT *
    FROM cte_ts_lower
)

SELECT *
FROM cte_ts_rename
