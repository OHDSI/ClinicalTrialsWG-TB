-------------------------------------------------------------------
-- Copyright 2024 Observational Health Data Sciences and Informatics
-- Clinical Trials Workgroup
-------------------------------------------------------------------

-- Count obs periods which has end date earlier than start date
-- Expected value: 0
SELECT
    COUNT(*)
FROM
    cdm.observation_period op
WHERE
    op.observation_period_end_date < observation_period_start_date;