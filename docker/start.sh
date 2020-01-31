#!/bin/bash -e
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

##
## @fn start.sh
##
## Automatically configures and starts Guacamole under Tomcat. Guacamole's
## guacamole.properties file will be automatically generated based on the
## linked database container (either MySQL or PostgreSQL) and the linked guacd
## container. The Tomcat process will ultimately replace the process of this
## script, running in the foreground until terminated.
##

GUACAMOLE_HOME_TEMPLATE="$GUACAMOLE_HOME"

GUACAMOLE_HOME="$HOME/.guacamole"
GUACAMOLE_EXT="$GUACAMOLE_HOME/extensions"
GUACAMOLE_LIB="$GUACAMOLE_HOME/lib"
GUACAMOLE_PROPERTIES="$GUACAMOLE_HOME/guacamole.properties"

DEBUG_LOG=${DEBUG_LOG:-0}

if [[ ${DEBUG_LOG} -eq 1 ]]; then
  env
  mkdir -p "$GUACAMOLE_HOME"
  ln -s /opt/guacamole/logback.xml "$GUACAMOLE_HOME/"
fi


##
## Sets the given property to the given value within guacamole.properties,
## creating guacamole.properties first if necessary.
##
## @param NAME
##     The name of the property to set.
##
## @param VALUE
##     The value to set the property to.
##
set_property() {

  NAME="$1"
  VALUE="$2"

  # Ensure guacamole.properties exists
  if [ ! -e "$GUACAMOLE_PROPERTIES" ]; then
    mkdir -p "$GUACAMOLE_HOME"
    echo "# guacamole.properties - generated $(date)" >"$GUACAMOLE_PROPERTIES"
  fi

  # Set property
  echo "$NAME: $VALUE" >>"$GUACAMOLE_PROPERTIES"

}

##
## Sets the given property to the given value within guacamole.properties only
## if a value is provided, creating guacamole.properties first if necessary.
##
## @param NAME
##     The name of the property to set.
##
## @param VALUE
##     The value to set the property to, if any. If omitted or empty, the
##     property will not be set.
##
set_optional_property() {

  NAME="$1"
  VALUE="$2"

  # Set the property only if a value is provided
  if [ -n "$VALUE" ]; then
    set_property "$NAME" "$VALUE"
  fi

}

associate_anyhow_aws() {
  if [ -n "${AWS_PROFILE}" ]; then
    set_property "aws-profile" "${AWS_PROFILE}"
  fi
  if [ -n "${AWS_LAMBDA_FUNCTION}" ]; then
    set_property "aws-lambda-function" "${AWS_LAMBDA_FUNCTION}"
  fi
  if [ -n "${AWS_LAMBDA_USERNAME_KEY}" ]; then
    set_property "aws-lambda-username-key" "${AWS_LAMBDA_USERNAME_KEY}"
  fi
  if [ -n "${AWS_LAMBDA_REMOTE_ADDRESS_KEY}" ]; then
    set_property "aws-lambda-remote-address-key" "${AWS_LAMBDA_REMOTE_ADDRESS_KEY}"
  fi
  if [ -n "${AWS_LAMBDA_REMOTE_HOSTNAME_KEY}" ]; then
    set_property "aws-lambda-remote-hostname-key" "${AWS_LAMBDA_REMOTE_HOSTNAME_KEY}"
  fi
  if [ -n "${AWS_OVERRIDE_TYPESCRIPT_PATH}" ]; then
    set_property "aws-override-typescript-path" "${AWS_OVERRIDE_TYPESCRIPT_PATH}"
  fi
  if [ -n "${AWS_OVERRIDE_CREATE_TYPESCRIPT_PATH}" ]; then
    set_property "aws-override-create-typescript-path" "${AWS_OVERRIDE_CREATE_TYPESCRIPT_PATH}"
  fi
  if [ -n "${AWS_OVERRIDE_TYPESCRIPT_NAME}" ]; then
    set_property "aws-override-typescript-name" "${AWS_OVERRIDE_TYPESCRIPT_NAME}"
  fi
  if [ -n "${AWS_OVERRIDE_RECORDING_PATH}" ]; then
    set_property "aws-override-recording-path" "${AWS_OVERRIDE_RECORDING_PATH}"
  fi
  if [ -n "${AWS_OVERRIDE_CREATE_RECORDING_PATH}" ]; then
    set_property "aws-override-create-recording-path" "${AWS_OVERRIDE_CREATE_RECORDING_PATH}"
  fi
  if [ -n "${AWS_OVERRIDE_RECORDING_NAME}" ]; then
    set_property "aws-override-recording-name" "${AWS_OVERRIDE_RECORDING_NAME}"
  fi
  if [ -n "${AWS_OVERRIDE_RECORDING_EXCLUDE_OUTPUT}" ]; then
    set_property "aws-override-recording-exclude-output" "${AWS_OVERRIDE_RECORDING_EXCLUDE_OUTPUT}"
  fi
  if [ -n "${AWS_OVERRIDE_RECORDING_EXCLUDE_MOUSE}" ]; then
    set_property "aws-override-recording-exclude-mouse" "${AWS_OVERRIDE_RECORDING_EXCLUDE_MOUSE}"
  fi
  if [ -n "${AWS_OVERRIDE_RECORDING_INCLUDE_KEYS}" ]; then
    set_property "aws-override-recording-include-keys" "${AWS_OVERRIDE_RECORDING_INCLUDE_KEYS}"
  fi
  if [ -n "${AWS_OVERRIDE_ENABLE_SFTP}" ]; then
    set_property "aws-override-enable-sftp" "${AWS_OVERRIDE_ENABLE_SFTP}"
  fi
  if [ -n "${AWS_OVERRIDE_SFTP_ROOT_DIRECTORY}" ]; then
    set_property "aws-override-sftp-root-directory" "${AWS_OVERRIDE_SFTP_ROOT_DIRECTORY}"
  fi
  if [ -n "${AWS_DESCRIBE_EC2_INSTANCES}" ]; then
    set_property "aws-describe-ec2-instances" "${AWS_DESCRIBE_EC2_INSTANCES}"
  fi
  if [ -n "${AWS_DESCRIBE_EC2_INSTANCES_FILTER_BY_INSTANCE_VPC_ID}" ]; then
    set_property "aws-describe-ec2-instances-filter-by-instance-vpc-id" "${AWS_DESCRIBE_EC2_INSTANCES_FILTER_BY_INSTANCE_VPC_ID}"
  fi
  if [ -n "${AWS_DESCRIBE_EC2_INSTANCES_FILTER_VPC_ID}" ]; then
    set_property "aws-describe-ec2-instances-filter-vpc-id" "${AWS_DESCRIBE_EC2_INSTANCES_FILTER_VPC_ID}"
  fi
  if [ -n "${AWS_DESCRIBE_EC2_INSTANCES_FILTER_SUBNET_ID}" ]; then
    set_property "aws-describe-ec2-instances-filter-subnet-id" "${AWS_DESCRIBE_EC2_INSTANCES_FILTER_SUBNET_ID}"
  fi
  if [ -n "${AWS_DESCRIBE_EC2_INSTANCES_FILTER_INSTANCE_GROUP_NAME}" ]; then
    set_property "aws-describe-ec2-instances-filter-instance-group-name" "${AWS_DESCRIBE_EC2_INSTANCES_FILTER_INSTANCE_GROUP_NAME}"
  fi
  if [ -n "${AWS_DESCRIBE_EC2_INSTANCES_FILTER_INSTANCE_GROUP_ID}" ]; then
    set_property "aws-describe-ec2-instances-filter-instance-group-id" "${AWS_DESCRIBE_EC2_INSTANCES_FILTER_INSTANCE_GROUP_ID}"
  fi
  if [ -n "${AWS_ALWAYS_AUTHENTICATE}" ]; then
    set_property "aws-always-authenticate" "${AWS_ALWAYS_AUTHENTICATE}"
  fi

  chmod +x /opt/guacamole/*.py || true
  chmod +x /opt/guacamole/*.sh || true

  ln -s /opt/guacamole/guacamole-auth-anyhow-aws-*.jar "$GUACAMOLE_EXT"

  for FILE in /opt/guacamole/*.json /opt/guacamole/*.yaml /opt/guacamole/*.yml /opt/guacamole/*.xml /opt/guacamole/*.py /opt/guacamole/*.sh; do
    ln -s ${FILE} "$GUACAMOLE_HOME"
  done

}

associate_openid() {
  if [ -n "${OPENID_AUTHORIZATION_ENDPOINT}" ]; then
    set_property "openid-authorization-endpoint" "${OPENID_AUTHORIZATION_ENDPOINT}"
  fi
  if [ -n "${OPENID_JWKS_ENDPOINT}" ]; then
    set_property "openid-jwks-endpoint" "${OPENID_JWKS_ENDPOINT}"
  fi
  if [ -n "${OPENID_ISSUER}" ]; then
    set_property "openid-issuer" "${OPENID_ISSUER}"
  fi
  if [ -n "${OPENID_CLIENT_ID}" ]; then
    set_property "openid-client-id" "${OPENID_CLIENT_ID}"
  fi
  if [ -n "${OPENID_REDIRECT_URI}" ]; then
    set_property "openid-redirect-uri" "${OPENID_REDIRECT_URI}"
  fi
  if [ -n "${OPENID_USERNAME_CLAIM_TYPE}" ]; then
    set_property "openid-username-claim-type" "${OPENID_USERNAME_CLAIM_TYPE}"
  fi
  if [ -n "${OPENID_SCOPE}" ]; then
    set_property "openid-scope" "${OPENID_SCOPE}"
  fi
  if [ -n "${OPENID_ALLOWED_CLOCK_SKEW}" ]; then
    set_property "openid-allowed-clock-skew" "${OPENID_ALLOWED_CLOCK_SKEW}"
  fi
  if [ -n "${OPENID_MAX_TOKEN_VALIDITY}" ]; then
    set_property "openid-max-token-validity" "${OPENID_MAX_TOKEN_VALIDITY}"
  fi
  if [ -n "${OPENID_MAX_NONCE_VALIDITY}" ]; then
    set_property "openid-max-nonce-validity" "${OPENID_MAX_NONCE_VALIDITY}"
  fi
  ln -s /opt/guacamole/guacamole-auth-openid-*.jar "$GUACAMOLE_EXT"

}

##
## Starts Guacamole under Tomcat, replacing the current process with the
## Tomcat process. As the current process will be replaced, this MUST be the
## last function run within the script.
##
start_guacamole() {

  # Install webapp
  ln -sf /opt/guacamole/guacamole.war /usr/local/tomcat/webapps/

  # Start tomcat
  cd /usr/local/tomcat
  exec catalina.sh run

}

#
# Start with a fresh GUACAMOLE_HOME
#

rm -Rf "$GUACAMOLE_HOME"

#
# Copy contents of provided GUACAMOLE_HOME template, if any
#

if [ -n "$GUACAMOLE_HOME_TEMPLATE" ]; then
  cp -a "$GUACAMOLE_HOME_TEMPLATE/." "$GUACAMOLE_HOME/"
fi

#
# Create and define Guacamole lib and extensions directories
#

mkdir -p "$GUACAMOLE_EXT"
mkdir -p "$GUACAMOLE_LIB"

#
# Point to associated guacd
#

# Use linked container for guacd if specified
if [ -n "$GUACD_NAME" ]; then
  GUACD_HOSTNAME="$GUACD_PORT_4822_TCP_ADDR"
  GUACD_PORT="$GUACD_PORT_4822_TCP_PORT"
fi

# Use default guacd port if none specified
GUACD_PORT="${GUACD_PORT-4822}"

# Verify required guacd connection information is present
if [ -z "$GUACD_HOSTNAME" -o -z "$GUACD_PORT" ]; then
  cat <<END
FATAL: Missing GUACD_HOSTNAME or "guacd" link.
-------------------------------------------------------------------------------
Every Guacamole instance needs a corresponding copy of guacd running. To
provide this, you must either:

(a) Explicitly link that container with the link named "guacd".

(b) If not using a Docker container for guacd, explicitly specify the TCP
		connection information using the following environment variables:

GUACD_HOSTNAME     The hostname or IP address of guacd. If not using a guacd
									 Docker container and corresponding link, this environment
									 variable is *REQUIRED*.

GUACD_PORT         The port on which guacd is listening for TCP connections.
									 This environment variable is optional. If omitted, the
									 standard guacd port of 4822 will be used.
END
  exit 1
fi

# Update config file
set_property "guacd-hostname" "$GUACD_HOSTNAME"
set_property "guacd-port" "$GUACD_PORT"

#
# Track which authentication backends are installed
#

INSTALLED_AUTH=""

if [ -n "$AWS_LAMBDA_FUNCTION" ]; then
  associate_anyhow_aws
  INSTALLED_AUTH="$INSTALLED_AUTH anyhow_aws"
elif [ -n "$AWS_DESCRIBE_EC2_INSTANCES" ]; then
  associate_anyhow_aws
  INSTALLED_AUTH="$INSTALLED_AUTH anyhow_aws"
fi

if [ -n "$OPENID_AUTHORIZATION_ENDPOINT" ]; then
  associate_openid
  INSTALLED_AUTH="$INSTALLED_AUTH openid"
fi

#
# Validate that at least one authentication backend is installed
#

if [ -z "$INSTALLED_AUTH" -a -z "$GUACAMOLE_HOME_TEMPLATE" ]; then
  cat <<END
FATAL: No authentication configured
-------------------------------------------------------------------------------
The Guacamole Docker container needs at least one authentication mechanism in
order to function, such as a MySQL database, PostgreSQL database, or LDAP
directory.  Please specify at least the MYSQL_DATABASE or POSTGRES_DATABASE
environment variables, or check Guacamole's Docker documentation regarding
configuring LDAP and/or custom extensions.
END
  exit 1
fi

#
# Finally start Guacamole (under Tomcat)
#

start_guacamole
