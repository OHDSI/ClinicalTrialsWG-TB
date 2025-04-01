-------------------------------------------------------------------
-- Copyright 2024 Observational Health Data Sciences and Informatics
-- Clinical Trials Workgroup
-------------------------------------------------------------------
TRUNCATE TABLE cdm.care_site;

INSERT INTO cdm.care_site
SELECT
    ROW_NUMBER() OVER ()    AS care_site_id,
	NULL                    AS care_site_name,
	0                       AS place_of_service_concept_id,
	loc.location_id         AS location_id,
	src.siteid              AS care_site_source_value,
	NULL                    AS place_of_service_source_value,
    'care_site.dm'          AS rule_id,
    src.src_tbl             AS src_tbl,
    NULL                    AS src_row
FROM
    src.dm  src
LEFT JOIN cdm.location loc
        ON loc.location_source_value = src.country
GROUP BY
    src.siteid,
    loc.location_id,
    src.src_tbl;
