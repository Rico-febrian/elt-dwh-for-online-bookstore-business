select *
from {{ source("pacbook-dwh", "order_history") }}