FROM postgres:9

ENV POSTGRES_DB=invoicing_database
ENV POSTGRES_USER=invoicing_database
ENV POSTGRES_PASSWORD=invoicing_database

RUN apt-get update -qq && \
    apt-get install -y apt-utils postgresql-contrib
