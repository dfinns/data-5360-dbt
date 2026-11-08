{{ config(
    materialized = 'table',
    database = 'group_8_project',
    schema = 'dw_ecoessentials'
)
}}

-- One row per person across both systems: ecommerce customers and SFMC email subscribers.
with ecommerce as (
    select
        customer_id,
        customer_first_name                     as first_name,
        customer_last_name                      as last_name,
        customer_phone                          as phone,
        customer_email                          as email_address,
        customer_address                        as address,
        customer_city                           as city,
        customer_state                          as state,
        lpad(customer_zip::varchar, 5, '0')     as zip,       -- keeps leading zeros (e.g. 05401)
        customer_country                        as country
    from {{ source('ecoessentials_landing', 'customer') }}
    where _fivetran_deleted = false
)

, subscribers as (
    select distinct
        subscriber_id,
        customer_id,
        subscriber_first_name,
        subscriber_last_name,
        subscriber_email
    from {{ ref('stg_email_events') }}
)

, purchasers as (
    select distinct customer_id
    from {{ source('ecoessentials_landing', 'orders') }}
    where _fivetran_deleted = false
)

, combined as (
    select
        e.customer_id,
        coalesce(e.first_name, s.subscriber_first_name)  as first_name,
        coalesce(e.last_name, s.subscriber_last_name)    as last_name,
        e.phone,
        coalesce(e.email_address, s.subscriber_email)    as email_address,
        e.address,
        e.city,
        e.state,
        e.zip,
        e.country,
        s.subscriber_id                                  as sfmc_subscriber_id,
        s.customer_id                                    as sfmc_customer_id,
        case
            when e.customer_id is not null and s.subscriber_id is not null then 'Ecommerce + SFMC'
            when e.customer_id is not null then 'Ecommerce'
            else 'SFMC'
        end                                              as source_system
    from ecommerce e
    full outer join subscribers s
        on e.customer_id = s.customer_id
)

select
    {{ dbt_utils.generate_surrogate_key(['c.customer_id', 'c.sfmc_subscriber_id']) }} as customer_key,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.phone,
    c.email_address,
    c.address,
    c.city,
    c.state,
    c.zip,
    c.country,
    c.sfmc_subscriber_id,
    c.sfmc_customer_id,
    c.source_system,
    p.customer_id is not null          as is_purchaser,
    c.sfmc_subscriber_id is not null   as is_email_subscriber
from combined c
left join purchasers p
    on c.customer_id = p.customer_id