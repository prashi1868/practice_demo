{%set list=[1] %}
select
  {% for i in  list  %}
    {{ i }} as id
    {% if not loop.last %},{% endif %} 
  {% endfor %} 