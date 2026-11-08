{{ config(
    materialized = 'table',
    database = 'group_8_project',
    schema = 'dw_ecoessentials'
)
}}

-- Cleans the SFMC email export once so every email dim and the fact read the same values.
select
    emaileventid                                    as email_event_id,
    emailid                                         as email_id,
    emailname                                       as email_name,
    campaignid                                      as campaign_id,
    replace(campaignname, '''''', '''')             as campaign_name,
    try_to_number(customerid)                       as customer_id,   -- source stores missing ids as the text 'NULL'
    subscriberid                                    as subscriber_id,
    subscriberemail                                 as subscriber_email,
    subscriberfirstname                             as subscriber_first_name,
    replace(subscriberlastname, '''''', '''')       as subscriber_last_name,
    sendtimestamp::timestamp_ntz                    as send_timestamp,
    upper(eventtype)                                as event_type,
    eventtimestamp::timestamp_ntz                   as event_timestamp
from {{ source('ecoessentials_landing', 'email_events') }}