{{ config(
    materialized = 'table',
    database = 'group_8_project',
    schema = 'dw_ecoessentials'
)
}}

with cte_date as (
    {{ dbt_date.get_date_dimension("2020-01-01", "2030-12-31") }}
)

select
    to_number(to_char(date_day, 'YYYYMMDD')) as date_key,
    date_day                                 as full_date,
    day_of_week,
    day_of_week_name                         as day_name,
    week_of_year,
    month_of_year                            as month,
    quarter_of_year                          as quarter,
    year_number                              as year
from cte_date