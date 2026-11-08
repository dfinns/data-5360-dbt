{{ config(
    materialized = 'table',
    database = 'group_8_project',
    schema = 'dw_ecoessentials'
)
}}

select distinct
    {{ dbt_utils.generate_surrogate_key(['event_type']) }} as event_type_key,
    event_type,
    case event_type
        when 'SENT'  then 'Email was sent to the subscriber'
        when 'OPEN'  then 'Subscriber opened the email'
        when 'CLICK' then 'Subscriber clicked a link in the email'
        else 'Other email event'
    end                                                  as event_description,
    event_type in ('OPEN', 'CLICK')                      as is_engagement
from {{ ref('stg_email_events') }}