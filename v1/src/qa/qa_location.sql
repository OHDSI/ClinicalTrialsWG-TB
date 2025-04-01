-------------------------------------------------------------------
-- Copyright 2024 Observational Health Data Sciences and Informatics
-- Clinical Trials Workgroup
-------------------------------------------------------------------

-- Count difference between the cdm and the source after filters
-- Expected value: 0
SELECT
(
    SELECT COUNT(*)
    FROM cdm.location
)
-
(
    SELECT COUNT(*)
    FROM
        (
            SELECT src.country
            FROM
                src.dm src
            WHERE
                country IS NOT NULL
            GROUP BY src.country
        ) tbl
);
