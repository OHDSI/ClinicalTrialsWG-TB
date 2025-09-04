WITH raw_events AS (
    SELECT
        ae.usubjid
        , ae.aestdy AS event_stdy
        , ae.visitnum
        , stcm.target_concept_id AS observation_concept_id
        , ae.aeterm AS observation_source_value
        , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS value_as_concept_id
    FROM {{ ref('stg_sdtm__ae') }} AS ae
    LEFT JOIN {{ ref('stg_stcm__source_to_concept_map')}} AS stcm
        ON
            ae.aeterm = stcm.source_code
            AND stcm.source_vocabulary_id = 'AETERM'
            AND stcm.target_domain_id = 'Observation'

    UNION ALL

    SELECT
        mh.usubjid
        , COALESCE(mh.mhstdy, mh.mhdy) AS event_stdy
        , mh.visitnum
        , 1340204 AS observation_concept_id -- History of event
        , mh.mhterm AS observation_source_value
        , stcm.target_concept_id AS value_as_concept_id
    FROM {{ ref('stg_sdtm__mh') }} AS mh
    LEFT JOIN {{ ref('stg_stcm__source_to_concept_map')}} AS stcm
        ON
            mh.mhterm = stcm.source_code
            AND stcm.source_vocabulary_id = 'MHTERM'

    UNION ALL

    SELECT
        usubjid
        , event_stdy
        , visitnum
        , observation_concept_id
        , observation_source_value
        , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS value_as_concept_id
    FROM {{ ref('int__trial_enrollment_outcome')}}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY per.person_id) AS observation_id
    , per.person_id
    , {{ dateadd(datepart="day", interval="event_stdy", from_date_or_timestamp="'2014-10-23'") }} AS observation_date
    , raw_events.observation_source_value
    , raw_events.observation_concept_id
    , raw_events.value_as_concept_id
    , vo.visit_occurrence_id
FROM raw_events
LEFT JOIN {{ ref('int__person') }} AS per
    ON raw_events.usubjid = per.person_source_value
LEFT JOIN {{ ref('int__visit_occurrence') }} AS vo
    ON
        raw_events.visitnum = vo.visitnum
        AND per.person_id = vo.person_id
