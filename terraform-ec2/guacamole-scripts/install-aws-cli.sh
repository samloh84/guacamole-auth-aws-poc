#!/bin/bash
set -euxo pipefail

yum install -y epel-release
yum install -y python3 python3-pip
pip3 install --upgrade pip awscli
