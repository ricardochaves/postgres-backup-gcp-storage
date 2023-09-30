# Postgres Backup GCP Storage
___
[![build and push images](https://github.com/ricardochaves/postgres-backup-gcp-storage/actions/workflows/build-and-push-images.yml/badge.svg)](https://github.com/ricardochaves/postgres-backup-gcp-storage/actions/workflows/build-and-push-images.yml)

This project use `pg_dumpall` command and `gsutil` to create a backup then send it do Google Cloud Store.

You can run once or schedule to run like a cronjob.

## Database passwords

The [pg_dumpall](https://www.postgresql.org/docs/current/app-pg-dumpall.html) will need the password over every database of your Postgres.

The best stratag is create your own [.pgpass](https://www.postgresql.org/docs/10/libpq-pgpass.html) file.

## Google Cloud Storage

You need a json key file of a Service Account with [Storage Object Creator](https://cloud.google.com/storage/docs/access-control/iam-roles#standard-roles) role.


## Setup

Create a volumn to add your `.pgpass` and `service_account_key.json` to your container.

You need use all of envs:
- `SERVICE_ACCOUNT_NAME`: Email of you service account
- `SERVICE_ACCOUNT_JSON_FILE`: Full path of the `service_account_key.json` file inside your container 
- `PGPASSFILE`: Full path of the `.pgpass` file inside your container
- `BUCKET_NAME`: The name of you Google Cloud Bucket
- `PGHOST`: Postgres Host
- `PGPORT`: Postgres Port
- `PGUSER`: Postgres User

## Using my docker compose

To build the project you need the `ALPINE_VERSION` and `TARGETARCH`. In my case, I'm using:

`docker compose build --build-arg ALPINE_VERSION=alpine3.18 --build-arg TARGETARCH=amd64`

## Using in your project:

This is an example of how to add the backup to your docker compose.

```yml
version: "3.8"
services:
  db:
    image: postgres:15-alpine3.18
    restart: always
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_DB=postgres
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - backup-net

  backup-db:
    image: ricardobchaves6/postgres-backup-gcp-storage:postgres15-alpine3.18
    networks:
      - backup-net
    depends_on:
      db:
        condition: service_healthy
    volumes:
      - ./.pgpass:/app/.pgpass
      - ./temp-oqu3b42h-1cb2f75b082e.json:/app/temp-oqu3b42h-1cb2f75b082e.json
    environment:
      - PGHOST=db
      - PGPORT=5432
      - PGUSER=postgres
      - SCHEDULE=@hourly
      - PGPASSFILE=/app/.pgpass
      - SERVICE_ACCOUNT_NAME=test-backup@temp-oqu3b42h.iam.gserviceaccount.com
      - SERVICE_ACCOUNT_JSON_FILE=/app/temp-oqu3b42h-1cb2f75b082e.json
      - BUCKET_NAME=test-backup-123kj

networks:
  backup-net:
```