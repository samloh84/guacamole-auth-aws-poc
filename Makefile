#!/usr/bin/make -f

SHELL = /bin/bash

.PHONY: build build_jar build_docker build_lambda apply_terraform destroy_terraform

all: build apply_terraform

build: build_jar build_docker build_lambda

build_jar:
	mvn clean compile package

build_docker:
	$(MAKE) -C docker build push

build_lambda:
	$(MAKE) -C lambda-guacamole-config build

apply_terraform:
	$(MAKE) -C terraform apply

destroy_terraform:
	$(MAKE) -C terraform destroy

invoke_lambda:
	$(MAKE) -C terraform invoke_lambda

ssh:
	$(MAKE) -C terraform ssh
