#!/usr/bin/make -f

SHELL = /bin/bash
BASE_IMAGE_NAME := guacamole/guacamole
BASE_IMAGE_TAG := latest
BASE_IMAGE_SHELL := bash
IMAGE_NAME := samloh84/guacamole-auth-anyhow-aws
IMAGE_TAG := latest
CONTAINER_NAME := guacamole

.PHONY: build_jar build clean bash base_bash push exec logs
all: build

build_jar:
	$(MAKE) -C ../ build_jar && cp ../target/guacamole-auth-anyhow-aws-1.0-SNAPSHOT.jar ./

build:
	if [[ ! -f guacamole-auth-anyhow-aws-1.0-SNAPSHOT.jar ]]; then $(MAKE) build_jar; fi
	docker build --rm --tag "${IMAGE_NAME}:${IMAGE_TAG}" .

clean:
	docker rmi --force "${IMAGE_NAME}:${IMAGE_TAG}"

bash:
	docker run --interactive --tty --rm "${IMAGE_NAME}:${IMAGE_TAG}" "${BASE_IMAGE_SHELL}"

base_bash:
	docker run --interactive --tty --rm "${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}" "${BASE_IMAGE_SHELL}"

run: build
	./run.sh

inspect:
	docker inspect "${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}"

push:
	docker push "${IMAGE_NAME}:${IMAGE_TAG}"

exec:
	docker exec -ti ${CONTAINER_NAME}

logs:
	docker exec -ti ${CONTAINER_NAME} bash -c 'cat /usr/local/tomcat/logs/*'
