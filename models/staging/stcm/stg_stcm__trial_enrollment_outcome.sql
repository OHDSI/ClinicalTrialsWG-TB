{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sctm', 'trial_enrollment_outcome') ) 
%}


WITH cte_te_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sctm','trial_enrollment_outcome') }}
)

, cte_te_rename AS (
    SELECT *
    FROM cte_te_lower
)

SELECT *
FROM cte_te_rename
