#!/usr/bin/make -f

SHELL = /bin/bash

.PHONY: clean plan apply destroy refresh output ssh scp invoke_lambda ssh_keygen build_lambda build_jar build_docker build

LAMBDA_FUNCTION := 'guacamole-config'

define BUILD_TERRAFORM_ARGS
VAR_FILE_ARGS="" && \
for VAR_FILE in $$(find . -name "*.tfvars"); \
do VAR_FILE_ARGS+=" -var-file=$${VAR_FILE}"; \
done
endef

all: apply

build: build_docker build_lambda build_jar

build_docker:
	$(MAKE) -C ../ build_docker

build_lambda:
	$(MAKE) -C ../ build_lambda

build_jar:
	$(MAKE) -C ../ build_jar

clean:
	rm -rf ./.terraform ./terraform.* ./.terraform*

ssh_keygen:
	ssh-keygen -f ~/.ssh/guacamole -t rsa -m PEM -b 4096 -a 100

plan:
	terraform init && \
	$(call BUILD_TERRAFORM_ARGS) && \
	terraform plan $${VAR_FILE_ARGS}

apply:
	if [[ ! -f ../lambda-guacamole-config/output/guacamole-config.zip ]]; then $(MAKE) -C ../lambda-guacamole-config build; fi
	terraform init && \
	$(call BUILD_TERRAFORM_ARGS) && \
	terraform apply $${VAR_FILE_ARGS} -auto-approve

destroy:
	terraform init && \
	$(call BUILD_TERRAFORM_ARGS) && \
	terraform destroy $${VAR_FILE_ARGS} -auto-approve

refresh:
	terraform init && \
	$(call BUILD_TERRAFORM_ARGS) && \
	terraform refresh $${VAR_FILE_ARGS}

output: refresh
	terraform output



ssh:
	SSH_SERVER=$$(terraform output -json | jq -r '.guacamole_ip.value') && \
	CENTOS_SERVER=$$(terraform output -json | jq -r '.centos_ip.value') && \
	WINDOWS_SERVER=$$(terraform output -json | jq -r '.windows_ip.value') && \
	eval $$(ssh-agent) && ssh-add ~/.ssh/guacamole && \
	SSH_ARGS="-o StrictHostKeyChecking=no" && \
	SSH_ARGS+=" -o ForwardAgent=yes" && \
	SSH_ARGS+=" -L63389:$${WINDOWS_SERVER}:3389" && \
	SSH_ARGS+=" -L6622:$${CENTOS_SERVER}:22" && \
	ssh $${SSH_ARGS} centos@$${SSH_SERVER}


ssh_centos:
	SSH_SERVER=$$(terraform output -json | jq -r '.guacamole_ip.value') && \
	CENTOS_SERVER=$$(terraform output -json | jq -r '.centos_ip.value') && \
	eval $$(ssh-agent) && ssh-add ~/.ssh/guacamole && \
	SSH_ARGS="-o StrictHostKeyChecking=no" && \
	SSH_ARGS+=" -o ForwardAgent=yes" && \
	SSH_ARGS+=" -J centos@$${SSH_SERVER}" && \
	ssh centos@$${CENTOS_SERVER}

scp:
	set -euxo pipefail; \
	SSH_SERVER=$$(terraform output -json | jq -r '.guacamole_ip.value'); \
	eval $$(ssh-agent) && ssh-add ~/.ssh/guacamole; \
	SSH_ARGS="-i ~/.ssh/guacamole -o StrictHostKeyChecking=no"; \
	scp $${SSH_ARGS} $$(find ./guacamole-scripts -name "*.sh") centos@$${SSH_SERVER}:/home/centos/; \
	ssh $${SSH_ARGS} centos@$${SSH_SERVER} 'chmod +x /home/centos/*.sh; sudo /home/centos/install-docker.sh; sudo /home/centos/install-aws-cli.sh; sudo /home/centos/run-guacamole.sh'


scp_centos:
	SSH_SERVER=$$(terraform output -json | jq -r '.guacamole_ip.value') && \
	CENTOS_SERVER=$$(terraform output -json | jq -r '.centos_ip.value') && \
	eval $$(ssh-agent) && ssh-add ~/.ssh/guacamole && \
	SSH_ARGS="-o StrictHostKeyChecking=no" && \
	SSH_ARGS+=" -o ForwardAgent=yes" && \
	SSH_ARGS+=" -J centos@$${SSH_SERVER}" && \
	ssh centos@$${CENTOS_SERVER} \
	sed -i -e 's:#PasswordAuthentication:PasswordAuthentication:g' /etc/ssh/sshd_config


invoke_lambda:
	aws lambda invoke --function-name ${LAMBDA_FUNCTION} /dev/stdout
