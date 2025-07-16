WITH cte_ta_te AS (
    SELECT DISTINCT
        armcd AS cd_code
        , {{ dbt.concat(["'Arm - '", "arm"]) }} AS cd_name
    FROM {{ source('sdtm', 'ta') }}

    UNION ALL

    SELECT DISTINCT
        etcd AS cd_code
        , {{ dbt.concat(["'Element - '", "element", "' - '", "testrl", "' through '", "teenrl"]) }} AS cd_name
    FROM {{ source('sdtm', 'te') }}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY cd_code) AS cohort_definition_id
    , cd_code AS cohort_definition_name
    , cd_name AS cohort_definition_description
FROM cte_ta_te
