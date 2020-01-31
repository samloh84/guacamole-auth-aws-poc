#!/usr/bin/make -f

SHELL = /bin/bash

.PHONY: build clean

all: build

build:
	npm install && \
	mkdir -p ./output && \
	zip -9 -q -r ./output/guacamole-config.zip ./index.js ./node_modules package.json package-lock.json

clean:
	rm -rf ./node_modules ./output
