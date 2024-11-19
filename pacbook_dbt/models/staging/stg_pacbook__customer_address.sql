select *
from {{ source("pacbook-dwh", "customer_address") }}