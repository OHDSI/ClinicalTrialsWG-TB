SELECT
    ROW_NUMBER() OVER (ORDER BY dm.usubjid) AS person_id
    , CASE
        WHEN dm.sex = 'M' THEN 8507
        WHEN dm.sex = 'F' THEN 8532
        ELSE 0
    END AS gender_concept_id
    , 2014 - {{ dbt.cast("dm.age", api.Column.translate_type("integer")) }} AS year_of_birth
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS month_of_birth
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS day_of_birth
    , {{ dbt.cast("NULL", api.Column.translate_type("datetime")) }} AS birth_datetime
    , CASE
        WHEN dm.race = 'BLACK OR AFRICAN AMERICAN' THEN 8516
        WHEN dm.race = 'WHITE' THEN 8527
        WHEN dm.race = 'NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER' THEN 8557
        ELSE 0
    END AS race_concept_id
    , CASE
        WHEN dm.ethnic = 'NOT HISPANIC OR LATINO' THEN 38003564
        ELSE 0
    END AS ethnicity_concept_id
    , loc.location_id
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS provider_id
    , cs.care_site_id
    , dm.usubjid AS person_source_value
    , dm.sex AS gender_source_value
    , 0 AS gender_source_concept_id
    , dm.race AS race_source_value
    , 0 AS race_source_concept_id
    , dm.ethnic AS ethnicity_source_value
    , 0 AS ethnicity_source_concept_id
FROM {{ ref('stg_sdtm__dm') }} AS dm
LEFT JOIN {{ ref('int__location') }} AS loc
    ON dm.country = loc.location_source_value
LEFT JOIN {{ ref('int__care_site') }} AS cs
    ON dm.siteid = cs.care_site_source_value
WHERE
    dm.usubjid IS NOT NULL
    AND dm.age IS NOT NULL
