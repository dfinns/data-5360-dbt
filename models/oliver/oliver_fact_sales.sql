{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

select
    o.order_id,
    c.cust_key,
    d.date_key,
    s.store_key,
    e.employee_key,
    o.total_amount as dollars_sold
from {{ source('oliver_landing', 'orders') }} o
join {{ ref('oliver_dim_customer') }} c on o.customer_id = c.customer_id
join {{ ref('oliver_dim_date') }}     d on o.order_date  = d.date_key
join {{ ref('oliver_dim_store') }}    s on o.store_id    = s.store_id
join {{ ref('oliver_dim_employee') }} e on o.employee_id = e.employee_id