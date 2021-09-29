{{
    config(
        materialized='table',
        unique_key='emp_id'
       
    )
}}


select
emp_id,
salary,
{{ rupee_to_dollar ('salary') }} as sal_in_dlr
from {{ source('ORGANIZATION', 'RAW_EMP') }}