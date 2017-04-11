#!/bin/sh

#Assign script parameters to name variables
export ID_DOMAIN=${1}
export REGION=${2}
export USER_ID=${3}
export USER_PASSWORD=${4}
export APP_NAME=${5}
export ARCHIVE_FILE=${6}


# If config.properties exists then read parameters from it
if [ -e "config.properties" ]; then
  echo "Reading config.properties"
  . config.properties
fi

if [ -z "$ID_DOMAIN" ] || [ -z "$REGION" ] || [ -z "$USER_ID" ] || [ -z "$USER_PASSWORD" ] || [ -z "$APP_NAME" ] || [ -z "$ARCHIVE_FILE" ]; then
  echo "usage: ${0} <id domain> <region us|europe> <user id> <user password> <app name> <archive file name>"
  exit -1
fi

if [ "$REGION" != "us" ] && [ "$REGION" != "europe" ]; then
  echo "Error: region must be one of 'us' or 'europe'"
  exit -1
fi

export ARCHIVE_BASENAME=$(basename "$ARCHIVE_FILE")

# Check to see if $ARCHIVE_FILE exists
if [ ! -e "$ARCHIVE_FILE" ]; then
  echo "Error: archive file not found '${ARCHIVE_FILE}'"
  exit -1
fi

# CREATE STORAGE CONTAINER
create_container="\
  curl -i -X PUT \
    -u ${USER_ID}:${USER_PASSWORD} \
    https://${ID_DOMAIN}.storage.oraclecloud.com/v1/Storage-$ID_DOMAIN/$APP_NAME"
echo ${create_container}
eval ${create_container}

# PUT ARCHIVE IN STORAGE CONTAINER
put_in_container="\
  curl -i -# -X PUT \
    -u ${USER_ID}:${USER_PASSWORD} \
    https://${ID_DOMAIN}.storage.oraclecloud.com/v1/Storage-$ID_DOMAIN/$APP_NAME/$ARCHIVE_BASENAME \
        -T $ARCHIVE_FILE | cat"
echo ${put_in_container}
eval ${put_in_container}

echo '\n[info] Upload to storage complete\n'
