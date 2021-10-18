select * 
from {{ ref('cust_loan') }}
where Status ='Active'