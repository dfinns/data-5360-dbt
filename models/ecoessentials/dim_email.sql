{{ config(
    materialized = 'table',
    database = 'group_8_project',
    schema = 'dw_ecoessentials'
)
}}

select distinct
    {{ dbt_utils.generate_surrogate_key(['email_id']) }} as email_key,
    email_id,
    email_name
from {{ ref('stg_email_events') }}