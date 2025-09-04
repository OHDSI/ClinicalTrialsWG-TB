{% set column_names = 
    dbt_utils.get_filtered_columns_in_relation( source('sctm', 'source_to_concept_map') ) 
%}


WITH cte_stcm_lower AS (

    SELECT
        {{ lowercase_columns(column_names) }}
    FROM {{ source('sctm','source_to_concept_map') }}
)

, cte_stcm_expand AS (
    SELECT
        stcm.source_code
        , stcm.source_concept_id
        , stcm.source_vocabulary_id
        , stcm.source_code_description
        , stcm.target_concept_id
        , stcm.target_vocabulary_id
        , stcm.valid_start_date
        , stcm.valid_end_date
        , concept.domain_id AS target_domain_id
    FROM cte_stcm_lower AS stcm
    INNER JOIN {{ ref('stg_vocabulary__concept')}} AS concept ON stcm.target_concept_id = concept.concept_id
)

SELECT *
FROM cte_stcm_expand
