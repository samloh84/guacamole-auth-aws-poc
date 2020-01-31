#!/bin/bash

INTERACTIVE=${INTERACTIVE:-0}


for SECRET_ENV in $(find . -name ".secret-env-*.sh"); do
  source ${SECRET_ENV}
done

docker pull guacamole/guacd:latest
docker pull samloh84/guacamole-auth-anyhow-aws:latest

docker rm -f guacamole guacd || true
docker network rm guacamole || true
docker network create guacamole

DOCKER_RUN_GUACD_ARGS=' --name guacd'
DOCKER_RUN_GUACD_ARGS+=' --restart unless-stopped'
DOCKER_RUN_GUACD_ARGS+=' --detach'
DOCKER_RUN_GUACD_ARGS+=' --network guacamole'

docker run ${DOCKER_RUN_GUACD_ARGS} guacamole/guacd:latest

DOCKER_RUN_GUACAMOLE_ARGS=' --name guacamole'
DOCKER_RUN_GUACAMOLE_ARGS+=' --restart unless-stopped'
DOCKER_RUN_GUACAMOLE_ARGS+=' --network guacamole'
DOCKER_RUN_GUACAMOLE_ARGS+=' --publish 8080:8080'

if [[ ${INTERACTIVE} -eq 1 ]]; then
  DOCKER_RUN_GUACAMOLE_ARGS+=' --tty'
  DOCKER_RUN_GUACAMOLE_ARGS+=' --interactive'
else
  DOCKER_RUN_GUACAMOLE_ARGS+=' --detach'
fi

DOCKER_RUN_GUACAMOLE_ARGS+=' --env GUACD_HOSTNAME=guacd'
DOCKER_RUN_GUACAMOLE_ARGS+=' --env GUACD_PORT=4822'
DOCKER_RUN_GUACAMOLE_ARGS+=' --env AWS_LAMBDA_FUNCTION=guacamole-config'
DOCKER_RUN_GUACAMOLE_ARGS+=" --env OPENID_AUTHORIZATION_ENDPOINT=${OPENID_AUTHORIZATION_ENDPOINT}"
DOCKER_RUN_GUACAMOLE_ARGS+=" --env OPENID_JWKS_ENDPOINT=${OPENID_JWKS_ENDPOINT}"
DOCKER_RUN_GUACAMOLE_ARGS+=" --env OPENID_ISSUER=${OPENID_ISSUER}"
DOCKER_RUN_GUACAMOLE_ARGS+=" --env OPENID_CLIENT_ID=${OPENID_CLIENT_ID}"
DOCKER_RUN_GUACAMOLE_ARGS+=" --env OPENID_REDIRECT_URI=https://guacamole.${DOMAIN_NAME}/guacamole"
DOCKER_RUN_GUACAMOLE_ARGS+=' --env AWS_REGION=ap-southeast-1'
DOCKER_RUN_GUACAMOLE_ARGS+=' --env DEBUG_LOG=1'

docker run ${DOCKER_RUN_GUACAMOLE_ARGS} samloh84/guacamole-auth-anyhow-aws:latest
