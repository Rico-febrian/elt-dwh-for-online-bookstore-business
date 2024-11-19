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

order_shipping as (
    select
        sco.order_id as nk_order_id, 
        date_trunc('day', sco.order_date) as order_date,
        cost
    from stg_cust_order sco
    left join stg_shipping_method ssm
        on ssm.method_id = sco.shipping_method_id
),

fct_book_sales as (
    select
        dd.date_actual as order_date,
        os.nk_order_id as dd_order_id,
        db.nk_book_id,
        count(sol.order_id) as total_book_sold,
	    (sum(sol.price) + sum(os.cost)) as total_revenue,
        {{ dbt_date.now() }} as created_at,
        {{ dbt_date.now() }} as updated_at
    from stg_order_line sol
    left join dim_books db
        on db.nk_book_id = sol.book_id
    left join order_shipping os
        on os.nk_order_id = sol.order_id
    left join dim_date dd
        on dd.date_actual = os.order_date
    group by 1, 2, 3
)

select * from fct_book_sales