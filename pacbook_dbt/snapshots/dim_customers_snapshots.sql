{% snapshot dim_customers_snapshot %}

{{
    config(
        target_database="pacbook-dwh",
        target_schema="snapshots",
        unique_key="sk_customer_id",

        strategy="check",
        check_cols=[
            'full_name',
            'email',
            'full_address',
            'city',
            'country_name',
            'address_status'
        ]
    )
}}

select *
from {{ ref("dim_customers") }} 

{% endsnapshot %}