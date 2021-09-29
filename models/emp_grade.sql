{{
    config(
        materialized='table',
        unique_key='emp_id',
        pre_hook="insert into raw_emp values (4,'rajesh','raj',25000) ;", 
        post_hook="select current_timestamp;" 

    )
}}
select
emp_id,
salary,
{{ grade ('salary') }} as grade
from {{ source('ORGANIZATION', 'RAW_EMP') }}