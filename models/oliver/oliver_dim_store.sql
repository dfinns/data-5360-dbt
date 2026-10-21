{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
)
}}

select
    store_id as store_key,
    store_id,
    store_name,
    street,
    city,
    state
from {{ source('oliver_landing', 'store')}}