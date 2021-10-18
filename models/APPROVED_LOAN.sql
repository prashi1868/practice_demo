{{
    config(
        materialized='table'

    )
}}

select a.CUST_ID,
a.CUST_NAME,
a.CUST_PHN,
a.CUST_DOB,
a.LOAN_AMOUNT,
{{ elg ('grade') }} as loan_status
from {{ ref('checking_old_loan') }} as a
left join {{ ref('cust_grade_report') }} AS b
on a.cust_id=b.cust_id
and grade not in ('AVERAGE','LEAST')
