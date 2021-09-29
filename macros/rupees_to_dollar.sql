{% macro rupee_to_dollar(column_name) %}
    ({{ column_name }} / 72.5) :: number(16, 2)
{% endmacro %}