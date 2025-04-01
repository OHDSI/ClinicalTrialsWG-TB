{% macro load_data_duckdb(file_dict, vocab_tables) %}

    {% if vocab_tables %}
        {% set target_schema = target.schema %}
    {% else %}
        {% set target_schema = target.schema ~ '_sdtm' %}
    {% endif %}

    {% do run_query("CREATE SCHEMA IF NOT EXISTS " ~ target_schema ~ ";") %}

    {% for n, p in file_dict.items() %}
        {% do run_query("DROP TABLE IF EXISTS " ~ target_schema ~ "." ~ n.lower() ~ ";") %}
        {% if n.lower() == "lb" %}
            {% do run_query("CREATE TABLE IF NOT EXISTS " ~ target_schema ~ "." ~ n.lower() ~ " AS SELECT * FROM read_csv('" ~ p ~ "', quote = '\"', types={'LBORNRLO': 'VARCHAR'});") %}
        {% elif vocab_tables %}
            {% do run_query("CREATE TABLE IF NOT EXISTS " ~ target_schema ~ "." ~ n.lower() ~ " AS SELECT * FROM read_csv('" ~ p ~ "', quote = '');") %}
        {% else %}
            {% do run_query("CREATE TABLE IF NOT EXISTS " ~ target_schema ~ "." ~ n.lower() ~ " AS SELECT * FROM read_csv('" ~ p ~ "', quote = '\"');") %}
        {% endif %}
    {% endfor %}

    {% if vocab_tables %}
        {% do run_query("ALTER TABLE " ~ target_schema ~ ".concept ALTER valid_start_date TYPE DATE USING strptime(CAST(valid_start_date AS VARCHAR), '%Y%m%d');") %}
        {% do run_query("ALTER TABLE " ~ target_schema ~ ".concept ALTER valid_end_date TYPE DATE USING strptime(CAST(valid_end_date AS VARCHAR), '%Y%m%d');") %}
        {% do run_query("ALTER TABLE " ~ target_schema ~ ".concept_relationship ALTER valid_start_date TYPE DATE USING strptime(CAST(valid_start_date AS VARCHAR), '%Y%m%d');") %}
        {% do run_query("ALTER TABLE " ~ target_schema ~ ".concept_relationship ALTER valid_end_date TYPE DATE USING strptime(CAST(valid_end_date AS VARCHAR), '%Y%m%d');") %}
        {% do run_query("ALTER TABLE " ~ target_schema ~ ".drug_strength ALTER valid_start_date TYPE DATE USING strptime(CAST(valid_start_date AS VARCHAR), '%Y%m%d');") %}
        {% do run_query("ALTER TABLE " ~ target_schema ~ ".drug_strength ALTER valid_end_date TYPE DATE USING strptime(CAST(valid_end_date AS VARCHAR), '%Y%m%d');") %}
    {% endif %}

{% endmacro %}
