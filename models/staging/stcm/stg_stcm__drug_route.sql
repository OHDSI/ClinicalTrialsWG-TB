{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sctm', 'drug_route') ) 
%}


WITH cte_dr_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sctm','drug_route') }}
)

, cte_dr_rename AS (
    SELECT *
    FROM cte_dr_lower
)

SELECT *
FROM cte_dr_rename
