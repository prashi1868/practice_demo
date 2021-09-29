{% macro grade (column_name) %}
    (CASE
		WHEN ({{ column_name }} >= 45000) THEN 'A'
		WHEN ({{ column_name }} >= 35000) THEN 'B'
		WHEN ({{ column_name }} >= 10000) THEN 'C'
	END) :: VARCHAR
{% endmacro %}