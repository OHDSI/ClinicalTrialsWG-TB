{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sctm', 'source_to_concept_map') ) 
%}


WITH cte_stcm_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sctm','source_to_concept_map') }}
)

, cte_stcm_rename AS (
-- TODO: rename columns to be human readable
    SELECT *
    FROM cte_stcm_lower
)

SELECT *
FROM cte_stcm_rename
