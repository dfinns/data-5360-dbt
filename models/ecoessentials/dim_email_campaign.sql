{{ config(
    materialized = 'table',
    database = 'group_8_project',
    schema = 'dw_ecoessentials'
)
}}

select distinct
    {{ dbt_utils.generate_surrogate_key(['campaign_id']) }} as email_campaign_key,
    campaign_id,
    campaign_name
from {{ ref('stg_email_events') }}