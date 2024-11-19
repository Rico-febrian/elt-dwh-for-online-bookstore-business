{% snapshot dim_books_snapshot %}

{{
    config(
        target_database="pacbook-dwh",
        target_schema="snapshots",
        unique_key="sk_book_id",

        strategy="check",
        check_cols=[
            'title',
            'author_name',
            'publisher_name',
            'language_name',
            'isbn13',
            'total_pages',
            'publication_date'
        ]
    )
}}

select *
from {{ ref("dim_books") }} 

{% endsnapshot %}