# Postgres Backup GCP Storage

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
