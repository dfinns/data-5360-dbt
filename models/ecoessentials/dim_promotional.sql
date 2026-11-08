{{ config(
    materialized = 'table',
    database = 'group_8_project',
    schema = 'dw_ecoessentials'
)
}}

with campaigns as (
    select
        campaign_id,
        campaign_name,
        campaign_discount
    from {{ source('ecoessentials_landing', 'promotional_campaign') }}
    where _fivetran_deleted = false

    union all

    -- default row so order lines with no campaign still get a valid key
    select -1, 'No Promotion', 0
)

select
    {{ dbt_utils.generate_surrogate_key(['campaign_id']) }} as promotional_campaign_key,
    campaign_id,
    campaign_name,
    campaign_discount
from campaigns