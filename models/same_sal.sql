select
	emp_id,
	fname,
	lname,
	'{{ var("salary") }}' as fixed_salary
from {{ source('ORGANIZATION', 'RAW_EMP') }}
where salary < 35000