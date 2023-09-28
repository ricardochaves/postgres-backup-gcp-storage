#! /bin/sh

set -eu

chmod 0600 $PGPASSFILE

timestamp=$(date +"%Y-%m-%dT%H:%M:%S")
local_file_name=db-$timestamp.dump.gz

echo "Creating backup of all databases into $local_file_name file"
pg_dumpall -l postgres | gzip > $local_file_name

/google-cloud-sdk/bin/gsutil cp /app/$local_file_name gs://$BUCKET_NAME

rm /app/$local_file_name
echo "File $local_file_name removed"
