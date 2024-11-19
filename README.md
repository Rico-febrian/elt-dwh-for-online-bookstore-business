# Port Database
Pada file docker-compose.yml, ubah port database sesuai dengan ketersediaan komputer lokal anda

    ports:
      - "[SRC_POSTGRES_PORT]:5432"

# Run Docker Compose
docker compose up -d

