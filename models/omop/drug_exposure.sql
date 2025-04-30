SELECT
    drug_exposure_id
    , person_id
    , drug_concept_id
    , drug_exposure_start_date
    , {{ dbt.cast("NULL", api.Column.translate_type("timestamp")) }} AS drug_exposure_start_datetime
    , drug_exposure_end_date
    , {{ dbt.cast("NULL", api.Column.translate_type("timestamp")) }} AS drug_exposure_end_datetime
    , {{ dbt.cast("NULL", api.Column.translate_type("date")) }} AS verbatim_end_date
    , drug_type_concept_id
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS stop_reason
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS refills
    -- TODO add quantity calculation based on cmdose, cmdoseu, cmdosfrq, cmstdy, cmendy
    , {{ dbt.cast("NULL", api.Column.translate_type("float")) }} AS quantity
    , days_supply
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS sig
    , route_concept_id
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS lot_number
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS provider_source_value
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS provider_id
    , visit_occurrence_id
    , {{ dbt.cast("NULL", api.Column.translate_type("integer")) }} AS visit_detail_id
    , drug_source_value
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS drug_source_concept_id
    , route_source_value
    , {{ dbt.cast("NULL", api.Column.translate_type("string")) }} AS dose_unit_source_value
FROM {{ ref('int__drug_exposure') }}
