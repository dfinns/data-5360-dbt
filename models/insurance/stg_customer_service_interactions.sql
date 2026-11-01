{{ config(
    materialized = 'table',
    schema = 'dw_insurance'
)}}

select
    "interaction_id"                         as interaction_id,
    split_part("customer_name", ' ', 1)      as customer_first_name,
    split_part("customer_name", ' ', 2)      as customer_last_name,
    "customer_email"                         as customer_email,
    split_part("agent_name", ' ', 1)         as agent_first_name,
    split_part("agent_name", ' ', 2)         as agent_last_name,
    "agent_email"                            as agent_email,
    "interaction_date"                       as interaction_date,
    "channel"                                as channel,
    "issue_type"                             as issue_type,
    "resolution_status"                      as resolution_status,
    "call_duration_min"                      as call_duration_min
from {{ source('insurance_gdrive', 'customer_service_interactions') }}
