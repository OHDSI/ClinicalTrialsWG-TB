SELECT
    ta.armcd AS arm_code
    , ta.arm AS arm_name
    , te.etcd AS element_code
    , te.element AS element_name
    , p.person_id AS subject_id
    , {{ dateadd(datepart="day", interval="se.sestdy", from_date_or_timestamp="'2014-10-23'") }} AS element_start_date
    , {{ dateadd(datepart="day", interval="se.seendy", from_date_or_timestamp="'2014-10-23'") }} AS element_end_date
    , MIN({{ dateadd(datepart="day", interval="se.sestdy", from_date_or_timestamp="'2014-10-23'") }}) OVER (PARTITION BY p.person_id, ta.armcd) AS arm_start_date
    , MAX({{ dateadd(datepart="day", interval="se.seendy", from_date_or_timestamp="'2014-10-23'") }}) OVER (PARTITION BY p.person_id, ta.armcd) AS arm_end_date
FROM {{ ref('stg_sdtm__dm') }} AS dm
INNER JOIN {{ ref('stg_sdtm__ta') }} AS ta
    ON dm.actarmcd = ta.armcd
INNER JOIN {{ ref('stg_sdtm__te') }} AS te
    ON ta.etcd = te.etcd
INNER JOIN {{ ref('stg_sdtm__se') }} AS se
    ON
        dm.usubjid = se.usubjid
        AND te.etcd = se.etcd
INNER JOIN {{ ref('int__person') }} AS p
    ON dm.usubjid = p.person_source_value
