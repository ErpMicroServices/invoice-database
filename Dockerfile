FROM postgres:latest

ENV POSTGRES_DB=invoice
ENV POSTGRES_USER=invoice
ENV POSTGRES_PASSWORD=invoice

# Copy all migration files to init directory
# PostgreSQL will execute these in alphabetical order on first run
COPY sql/V_invo*.sql /docker-entrypoint-initdb.d/

# Ensure the container uses UTF-8 encoding
ENV LANG=en_US.utf8
