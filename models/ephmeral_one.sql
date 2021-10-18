{{
    config(
        materialized='ephemeral'
    )
}}

with eph as (
    
select cust_id,
cust_name,
cust_phn,
L_amount,
missed_onTime_payment,
dense_rank() over (order by  missed_onTime_payment asc )
from {{ ref('cust_loan') }}

)

select * from eph 