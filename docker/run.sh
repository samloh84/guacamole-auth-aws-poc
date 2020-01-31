#!/bin/bash

set -euxo pipefail

for SECRET_ENV in $(find . -name ".secret-env-*.sh"); do
  source ${SECRET_ENV}
done

docker rm -f guacd guacamole || true
docker network rm guacamole || true
docker network create guacamole

docker run \
  --name guacd \
  --restart unless-stopped \
  --detach \
  --network guacamole \
  guacamole/guacd

docker run \
  --name guacamole \
  --restart unless-stopped \
  --network guacamole \
  --publish 8080:8080 \
  --tty \
  --interactive \
  --env "GUACD_HOSTNAME=guacd" \
  --env "AWS_LAMBDA_FUNCTION=guacamole-config" \
  --env "OPENID_AUTHORIZATION_ENDPOINT=$${OPENID_AUTHORIZATION_ENDPOINT" \
  --env "OPENID_JWKS_ENDPOINT=$${OPENID_JWKS_ENDPOINT}" \
  --env "OPENID_ISSUER=$${OPENID_ISSUER}" \
  --env "OPENID_CLIENT_ID=$${OPENID_CLIENT_ID}" \
  --env "OPENID_REDIRECT_URI=http://localhost:8080/guacamole" \
  --env "AWS_SESSION_TOKEN=$${AWS_SESSION_TOKEN}" \
  --env "AWS_SECRET_ACCESS_KEY=$${AWS_SECRET_ACCESS_KEY}" \
  --env "AWS_ACCESS_KEY_ID=$${AWS_ACCESS_KEY_ID}" \
  --env "AWS_REGION=$${AWS_REGION}" \
  --env "DEBUG_LOG=$${DEBUG_LOG}" \
  "${IMAGE_NAME}:${IMAGE_TAG}"
