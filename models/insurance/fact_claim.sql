{{ config(
    materialized = 'table',
    schema = 'dw_insurance'
)}}

select
    p.policy_key,
    cu.customer_key,
    a.agent_key,
    d.date_key,
    c.claimamount
from {{ source('insurance_landing', 'claims')}} c 
inner join {{ source('insurance_landing', 'policies')}} pd 
    on c.policyid = pd.policyid
inner join {{ ref("dim_policy")}} p 
    on pd.policyid = p.policyid
inner join {{ ref('dim_customer')}} cu 
    on pd.customerid = cu.customerid
inner join {{ ref('dim_agent')}} a 
    on pd.agentid = a.agentid
inner join {{ ref('dim_date')}} d 
    on c.claimdate = d.date_day
