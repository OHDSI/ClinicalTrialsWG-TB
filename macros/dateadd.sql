{% macro dateadd(datepart, interval, from_date_or_timestamp) %}
    {% if target.type == 'duckdb' %}
        -- Custom logic for DuckDB
        {% if datepart == 'day' %}
            date_add(DATE {{ from_date_or_timestamp }}, interval ({{ interval }}) day)
        {% elif datepart == 'month' %}
            date_add(DATE {{ from_date_or_timestamp }}, interval ({{ interval }}) month)
        {% elif datepart == 'year' %}
            date_add(DATE {{ from_date_or_timestamp }}, interval ({{ interval }}) year)
        {% else %}
            {{ exceptions.raise_compiler_error("Unsupported datepart or from date for DuckDB") }}
        {% endif %}
    {% else %}
        -- Default logic for other databases
        {{ dbt.dateadd(datepart=datepart, interval=interval, from_date_or_timestamp=from_date_or_timestamp) }}
    {% endif %}
{% endmacro %}