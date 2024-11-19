select *
from {{ source("pacbook-dwh", "shipping_method") }}