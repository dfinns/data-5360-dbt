{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

select
    d.date_key,
    e.employee_key,
    c.certification_name,
    c.certification_cost
from {{ ref('stg_employee_certifications') }} c
join {{ ref('oliver_dim_date') }}     d on c.certification_awarded_date = d.date_key
join {{ ref('oliver_dim_employee') }} e on c.employee_id = e.employee_id