select *
from {{ source("pacbook-dwh", "book") }}