select *
from {{ source("pacbook-dwh", "book_author") }}