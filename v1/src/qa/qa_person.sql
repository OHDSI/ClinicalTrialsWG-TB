-------------------------------------------------------------------
-- Copyright 2024 Observational Health Data Sciences and Informatics
-- Clinical Trials Workgroup
-------------------------------------------------------------------

-- Count difference between the cdm and the source after filters
-- Expected value: 0
SELECT
(
    SELECT COUNT(*)
    FROM cdm.person
)
-
(
    SELECT COUNT(*)
    FROM
        (
            SELECT src.usubjid
            FROM
                src.dm src
            WHERE
                usubjid IS NOT NULL
                AND src.age IS NOT NULL
            GROUP BY src.usubjid
            HAVING COUNT(*) = 1
        ) tbl
);