{{ config(
    materialized = 'table',
    database = 'group_8_project',
    schema = 'dw_ecoessentials'
)
}}

select
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
    product_id,
    product_name,
    product_type,
    price as list_price
from {{ source('ecoessentials_landing', 'product') }}
where _fivetran_deleted = false