{{
    config(
        materialized='table'
    )
}}


with stg_author as (
    select *
    from {{ ref("stg_pacbook__author") }}
),

stg_book_author as (
    select *
    from {{ ref("stg_pacbook__book_author") }}
),

book_author_detail as (
    select 
        sba.book_id,
        string_agg(sa.author_name, ', ') as author_name
    from stg_book_author sba
    left join stg_author sa
        on sa.author_id = sba.author_id
    group by 1
),

stg_book as (
    select *
    from {{ ref("stg_pacbook__book") }}
),

stg_book_language as (
    select *
    from {{ ref("stg_pacbook__book_language") }}
),

stg_publisher as (
    select *
    from {{ ref("stg_pacbook__publisher") }}
),

dim_books as (
    select
        sb.book_id as nk_book_id,
        sb.title,
        coalesce(bad.author_name, 'Unknown Author') as author_name,
        sb.num_pages as total_pages,
        sb.publication_date,
        sp.publisher_name,
        sbl.language_name,
        sbl.language_code,
        sb.isbn13
    from stg_book sb
    left join stg_book_language sbl
        on sbl.language_id = sb.language_id
    left join book_author_detail bad
        on bad.book_id = sb.book_id
    left join stg_publisher sp
        on sp.publisher_id = sb.publisher_id
),

final_dim_books as (
    select
        {{ dbt_utils.generate_surrogate_key( ["nk_book_id"] ) }} as sk_book_id,
        *,
        {{ dbt_date.now() }} as created_at,
        {{ dbt_date.now() }} as updated_at
    from dim_books
)

select * from final_dim_books
