SELECT
    ROW_NUMBER() OVER (ORDER BY per.person_id, cm.cmstdy) AS drug_exposure_id
    , per.person_id
    , {{ dateadd(datepart="day", interval="cm.cmstdy", from_date_or_timestamp="'2014-10-23'") }} AS drug_exposure_start_date
    , CASE
        WHEN cm.cmendy IS NOT NULL THEN {{ dateadd(datepart="day", interval="cm.cmendy", from_date_or_timestamp="'2014-10-23'") }}
        -- TODO add proper THEMIS imputation rules
        ELSE {{ dateadd(datepart="day", interval="cm.cmstdy", from_date_or_timestamp="'2014-10-23'") }}
    END AS drug_exposure_end_date
    , cm.cm_concat AS drug_source_value
    , stcm.target_concept_id AS drug_concept_id
    , 32809 AS drug_type_concept_id  -- 'Case Report Form'
    , cm.cmendy - cm.cmstdy + 1 AS days_supply
    , dr.concept_id AS route_concept_id
    , cm.cmroute AS route_source_value
    , vo.visit_occurrence_id
FROM {{ ref('stg_sdtm__cm') }} AS cm
LEFT JOIN {{ ref('int__person') }} AS per
    ON cm.usubjid = per.person_source_value
LEFT JOIN {{ ref('int__visit_occurrence') }} AS vo
    ON
        cm.visitnum = vo.visit_source_value
        AND per.person_id = vo.person_id
LEFT JOIN {{ ref('stg_stcm__source_to_concept_map')}} AS stcm
    ON
        cm.cm_concat = stcm.source_code
        AND stcm.source_vocabulary_id = 'TB1015_CM'
LEFT JOIN {{ ref('stg_stcm__drug_route')}} AS dr
    ON UPPER(TRIM(cm.cmroute)) = dr.route
