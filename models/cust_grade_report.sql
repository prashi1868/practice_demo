{{
    config(
        materialized='table'

    )
}}
select
Cust_id,
cust_name,
L_amount,
missed_onTime_payment,
{{ grade ('missed_onTime_payment') }} as grade
from {{ ref('cust_loan') }}