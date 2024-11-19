{{
    config(
        materialized='table'
    )
}}


with stg_country as (
    select *
    from {{ ref("stg_pacbook__country") }}
),

stg_address as (
    select *
    from {{ ref("stg_pacbook__address") }}
),

stg_customer_address as (
    select *
    from {{ ref("stg_pacbook__customer_address") }}
),

stg_address_status as (
    select *
    from {{ ref("stg_pacbook__address_status") }}
),

stg_customer as (
    select *
    from {{ ref("stg_pacbook__customer") }}
),

address_country as (
    select *
    from stg_address sa
    join stg_country sc
        on sc.country_id = sa.country_id
),

cust_address_detail as (
    select *
    from stg_customer_address sca
    join address_country ac
        on ac.address_id = sca.address_id
    join stg_address_status sas
        on sas.status_id = sca.status_id
),

dim_customers as (
    select
        sc.customer_id as nk_customer_id,
        concat(sc.first_name, ' ', sc.last_name) as full_name,
        concat(cad.street_number, ' ', cad.street_name) as full_address,
        cad.city,
        cad.country_name,
        cad.address_status,
        sc.email
    from stg_customer sc
    join cust_address_detail cad
        on cad.customer_id = sc.customer_id
),

final_dim_customers as (
    select
        {{ dbt_utils.generate_surrogate_key( ["nk_customer_id", "full_name", "full_address"] ) }} as sk_customer_id,
        *,
        {{ dbt_date.now() }} as created_at,
        {{ dbt_date.now() }} as updated_at
    from dim_customers
)

select * from final_dim_customers