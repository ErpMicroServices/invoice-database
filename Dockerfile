FROM postgres:10

ENV POSTGRES_DB=invoice_database
ENV POSTGRES_USER=invoice_database
ENV POSTGRES_PASSWORD=invoice_database

RUN apt-get update -qq && \
    apt-get install -y apt-utils postgresql-contrib

COPY build/database_up.sql /docker-entrypoint-initdb.d/
