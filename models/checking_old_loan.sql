{{
    config(
        materialized='table'

    )
}}

select * 
from {{ ref('New_Loan_applications') }}
where cust_id Not in (select cust_id 
from {{ref ('active_loan') }} )