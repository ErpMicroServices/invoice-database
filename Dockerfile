FROM postgres:9.6.1

ENV POSTGRES_DB=invoice_database
ENV POSTGRES_USER=invoice_database
ENV POSTGRES_PASSWORD=invoice_database

RUN apt-get update -qq && \
    apt-get install -y apt-utils postgresql-contrib

ADD *.sql /docker-entrypoint-initdb.d/
