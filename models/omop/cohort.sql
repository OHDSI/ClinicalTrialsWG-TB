SELECT DISTINCT
    cda.cohort_definition_id
    , a.subject_id
    , cda.arm_start_date AS cohort_start_date
    , cda.arm_end_date AS cohort_end_date
FROM {{ ref('int__arms_elements') }} AS a
INNER JOIN {{ ref('int__cohort_definition') }} AS cda
    ON a.arm_code = cda.cohort_definition_name

UNION ALL

SELECT DISTINCT
    cde.cohort_definition_id
    , a.subject_id
    , cde.element_start_date AS cohort_start_date
    , cde.element_end_date AS cohort_end_date
FROM {{ ref('int__arms_elements') }} AS a
INNER JOIN {{ ref('int__cohort_definition') }} AS cde
    ON a.element_code = cde.cohort_definition_name
