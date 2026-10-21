{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

select
    -- order
    f.order_id,
    f.dollars_sold,

    -- date
    d.date_day          as order_date,
    d.day_of_week,
    d.month_name,
    d.month_of_year,
    d.quarter_of_year,
    d.year_number,

    -- customer
    c.customer_id,
    c.first_name || ' ' || c.last_name as customer_name,
    c.email             as customer_email,
    c.state             as customer_state,

    -- store
    s.store_id,
    s.store_name,
    s.city              as store_city,
    s.state             as store_state,

    -- employee
    e.employee_id,
    e.first_name || ' ' || e.last_name as employee_name,
    e.position          as employee_position,
    e.hire_date         as employee_hire_date

from {{ ref('oliver_fact_sales') }} f
left join {{ ref('oliver_dim_date') }}     d on f.date_key     = d.date_key
left join {{ ref('oliver_dim_customer') }} c on f.cust_key     = c.cust_key
left join {{ ref('oliver_dim_store') }}    s on f.store_key    = s.store_key
left join {{ ref('oliver_dim_employee') }} e on f.employee_key = e.employee_key