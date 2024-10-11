-------------------------------------------------------------------
-- Copyright 2024 Observational Health Data Sciences and Informatics
-- Clinical Trials Workgroup
-------------------------------------------------------------------

-- Count difference between the cdm and the source after filters
-- Expected value: 0
SELECT
(
    SELECT COUNT(*)
    FROM cdm.care_site
)
-
(
    SELECT COUNT(*)
    FROM
        (
            SELECT src.siteid
            FROM
                src.dm src
            WHERE
                siteid IS NOT NULL
            GROUP BY src.siteid
        ) tbl
);