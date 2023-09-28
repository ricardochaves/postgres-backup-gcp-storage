#! /bin/sh

set -eu

/google-cloud-sdk/bin/gcloud auth activate-service-account $SERVICE_ACCOUNT_NAME --key-file $SERVICE_ACCOUNT_JSON_FILE

if [ -z "$SCHEDULE" ]; then
  sh backup.sh
else
  exec go-cron "$SCHEDULE" /bin/sh backup.sh
fi
