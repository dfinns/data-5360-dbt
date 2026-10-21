{{config(
        materialized='table',
        schema='dw_insurance'
        )

}}

select 
    agentid as agent_key,
    agentid,
    firstname,
    lastname,
    email,
    phone
from {{source('insurance_landing', 'agents')}}