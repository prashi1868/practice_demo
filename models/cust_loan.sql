{{
    config(
        materialized='incremental',
        unique_key='cust_id',
        merge_update_columns = ['cust_phn']
    )
}}

select a.cust_id,a.cust_name,a.cust_phn,b.L_amount,b.missed_onTime_payment,b.status
from {{ ref('cust_detail') }} AS a
left join {{ ref('loan_dt') }} AS b
on a.cust_id=b.cust_id

