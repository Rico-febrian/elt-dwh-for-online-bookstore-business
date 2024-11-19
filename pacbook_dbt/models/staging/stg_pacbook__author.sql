select *
from {{ source("pacbook-dwh", "author") }}