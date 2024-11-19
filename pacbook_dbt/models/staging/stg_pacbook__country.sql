select *
from {{ source("pacbook-dwh", "country") }}