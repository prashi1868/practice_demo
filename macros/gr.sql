{% macro grade (column_name) %}
    (CASE
		WHEN ({{ column_name }} <= 2 ) THEN 'GOOD'
		WHEN ({{ column_name }} <= 5 ) THEN 'AVERAGE'
		WHEN ({{ column_name }} > 5) THEN 'LEAST'
	END) :: VARCHAR
{% endmacro %}