FROM postgres:9

ENV POSTGRES_DB=invoicing-database
ENV POSTGRES_USER=invoicing-database
ENV POSTGRES_PASSWORD=invoicing-database

RUN apt-get update -qq && \
    apt-get install -y apt-utils postgresql-contrib
