#!/bin/sh

echo "ORA_APP_NAME: ${ORA_APP_NAME}"

# Launch the jar identifying the Main program to run with ${1}
# that is passed in from the manifest.json start command
java \
  -DREGISTRY_URL=${REGISTRY_URL} \
  -DORA_APP_NAME=${ORA_APP_NAME} \
  -DPORT=${PORT} \
  -Dspring.profiles.active=cloud\
  -jar microservices-example-1.1.0.RELEASE.jar ${1}
