select *
from {{ source("pacbook-dwh", "cust_order") }}