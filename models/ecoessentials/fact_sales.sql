{{ config(
    materialized = 'table',
    database = 'group_8_project',
    schema = 'dw_ecoessentials'
)
}}

-- Grain: one row per order line.
-- price_after_discount in the source is the line's net total (list price x quantity x (1 - discount)).
with lines as (
    select
        ol.order_id,
        ol.order_line_id,
        ol.product_id,
        coalesce(ol.campaign_id, -1)    as campaign_id,
        ol.quantity,
        ol.price_after_discount         as net_sales_amount,
        o.customer_id,
        o.order_timestamp::timestamp_ntz as order_timestamp
    from {{ source('ecoessentials_landing', 'order_line') }} ol
    join {{ source('ecoessentials_landing', 'orders') }} o
        on ol.order_id = o.order_id
    where ol._fivetran_deleted = false
      and o._fivetran_deleted = false
)

select
    d.date_key,
    c.customer_key,
    p.product_key,
    pr.promotional_campaign_key,
    to_number(to_char(l.order_timestamp, 'HH24MI'))         as time_key,
    l.order_id,
    l.order_line_id,
    l.quantity,
    p.list_price                                            as unit_price,
    l.quantity * p.list_price                               as gross_sales_amount,
    round(l.quantity * p.list_price - l.net_sales_amount, 2) as discount_amount,
    l.net_sales_amount
from lines l
left join {{ ref('eco_dim_date') }}        d  on d.full_date   = l.order_timestamp::date
left join {{ ref('eco_dim_customer') }}    c  on c.customer_id = l.customer_id
left join {{ ref('dim_product') }}     p  on p.product_id  = l.product_id
left join {{ ref('dim_promotional') }} pr on pr.campaign_id = l.campaign_id