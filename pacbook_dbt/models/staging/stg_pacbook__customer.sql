select *
from {{ source("pacbook-dwh", "customer") }}