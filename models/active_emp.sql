select a.emp_id, a.salary, a.grade, b.SAL_IN_DLR
from {{ ref('emp_grade') }} AS a
left join {{ ref('emp_sal_usd') }} as b
on a.emp_id = b.emp_id