{% test exceptionn(Loan_id) %}

{% if Loan_id < 100 %}
  {{ exceptions.raise_compiler_error("Invalid `Loan_id`. Got: " ~ Loan_id) }}
{% endif %}

{% endtest %}