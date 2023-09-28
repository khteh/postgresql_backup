#!/bin/bash
set -x
#CONNECTION_STRING=
#POSTGRESQL_USER=
#POSTGRES_DB=
#PGPASSWORD=
#S3_BUCKET=
#cd /home/root
aws configure set default.region ap-southeast-1
aws configure set aws_access_key_id ${AWS_ACCESS_KEY}
aws configure set aws_secret_access_key ${AWS_SECRET}

date1=$(date +%Y%m%d-%H%M)
mkdir -p pg-backup
PGPASSWORD="$PGPASSWORD" pg_dump -h $CONNECTION_STRING -U $POSTGRESQL_USER $POSTGRES_DB > pg-backup/${POSTGRES_DB}.sql
PGPASSWORD="$PGPASSWORD" pg_dump -h $CONNECTION_STRING -U $POSTGRESQL_USER --column-inserts --data-only $POSTGRES_DB  > pg-backup/${POSTGRES_DB}_data.sql
file_name="pg-backup-"$date1".tgj"

#Compressing backup file for upload
tar jcvf $file_name pg-backup

#notification_msg="Postgres-Backup-failed"
filesize=$(stat -c %s $file_name)
mfs=10
if [[ "$filesize" -gt "$mfs" ]]; then
  # Uploading to s3
  aws s3 cp $file_name s3://$S3_BUCKET/$file_name
  notification_msg="Postgres-Backup-was-successful"
fi

#Slack notification of successful / unsuccesful backup. 
#send_slack_notification()
#{
#payload='payload={"text": "'$1'"}'
#  cmd1= curl --silent --data-urlencode \
#    "$(printf "%s" $payload)" \
#    ${APP_SLACK_WEBHOOK} || true
#}
#send_slack_notification $notification_msg
