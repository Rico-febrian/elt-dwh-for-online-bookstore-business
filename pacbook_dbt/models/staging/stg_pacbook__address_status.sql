select *
from {{ source("pacbook-dwh", "address_status") }}