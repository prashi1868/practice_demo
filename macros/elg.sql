{% macro elg (column_name) %}
    (CASE
		WHEN ({{ column_name }} = 'GOOD' ) THEN 'APPROVED'
		WHEN ({{ column_name }} = 'AVERAGE' ) THEN 'PENDING'
		WHEN ({{ column_name }} = 'LEAST') THEN 'REJECT'
	END) :: VARCHAR
{% endmacro %}