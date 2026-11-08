{{ config(
    materialized = 'table',
    database = 'group_8_project',
    schema = 'dw_ecoessentials'
)
}}

-- Grain: one row per email event (sent, open, or click).
select
    d.date_key,
    em.email_key,
    ec.email_campaign_key,
    c.customer_key,
    et.event_type_key,
    to_number(to_char(e.event_timestamp, 'HH24MI'))                   as time_key,
    e.email_event_id,
    1                                                                 as event_count,
    datediff('minute', e.send_timestamp, e.event_timestamp)           as minutes_from_send_to_event
from {{ ref('stg_email_events') }} e
left join {{ ref('eco_dim_date') }}           d  on d.full_date          = e.event_timestamp::date
left join {{ ref('dim_email') }}          em on em.email_id          = e.email_id
left join {{ ref('dim_email_campaign') }} ec on ec.campaign_id       = e.campaign_id
left join {{ ref('eco_dim_customer') }}       c  on c.sfmc_subscriber_id = e.subscriber_id
left join {{ ref('dim_event_type') }}     et on et.event_type        = e.event_type