select *
from {{ source("pacbook-dwh", "publisher") }}