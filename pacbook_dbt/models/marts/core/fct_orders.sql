{{
    config(
        materialized='table'
    )
}}


with dim_date as (
    select * 
    from {{ ref("dim_date") }}
),

dim_customers as (
    select *
    from {{ ref("dim_customers") }}
),

dim_books as (
    select *
    from {{ ref("dim_books") }}
),

stg_cust_order as (
    select *
    from {{ ref("stg_pacbook__cust_order") }}
),

stg_order_line as (
    select *
    from {{ ref("stg_pacbook__order_line") }}
),

stg_shipping_method as (
    select *
    from {{ ref("stg_pacbook__shipping_method") }}
),

order_details as (
    select 
        sco.order_id as nk_order_id,
        sco.customer_id,
        date(sco.order_date) as order_date,
        count(sol.line_id) as order_qty,
        sum(sol.price) as total_book_price,
        sum(ssm.cost) as total_shipping_cost,
        (sum(sol.price) + sum(ssm.cost)) as total_cost
    from stg_cust_order sco
    join stg_order_line sol
        on sol.order_id = sco.order_id
    join stg_shipping_method ssm
        on ssm.method_id = sco.shipping_method_id
    group by 1, 2, 3
),

repeat_customer_check as (
    select
        customer_id,
        count(nk_order_id) as total_order,
        case 
            when count(nk_order_id) > 1 then 'Yes'
            else 'No'
        end as is_repeat_customer
    from order_details od
    group by 1
),

fct_orders as (
    select distinct
        {{ dbt_utils.generate_surrogate_key( ["od.nk_order_id"] ) }} as sk_order_id,
        od.nk_order_id as dd_order_id,
        dc.nk_customer_id,
        rcc.is_repeat_customer,
        dd.date_actual as order_date,
        od.order_qty,
        od.total_book_price,
        od.total_shipping_cost,
        od.total_cost,
        {{ dbt_date.now() }} as created_at,
        {{ dbt_date.now() }} as updated_at
    from order_details od
    join dim_customers dc
        on dc.nk_customer_id = od.customer_id
    join dim_date dd
        on dd.date_actual = od.order_date
    join repeat_customer_check rcc
        on rcc.customer_id = od.customer_id
)

select * from fct_orders
