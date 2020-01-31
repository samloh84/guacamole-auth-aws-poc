# Guacamole AWS Authentication Proof of Concept
This repo contains the following:

* Source code for a Guacamole AWS extension
* Dockerfile to build a custom docker container containing OIDC and the built Guacamole AWS extensions
* Terraform IaC to build a terraform environment to test the extension.
* Source code for an AWS Lambda to supply EC2 instance data to the Guacamole AWS Extension


Notes:
* In order for RDP on EC2 Windows Server to work without providing credentials through the lambda:
    1. Disable NLA
    2. Set 'security' parameter to 'tls'
    
* In order for SSH to work on EC2 Centos without providing a certificate through the lambda:
    1. Enable PasswordAuthentication on /etc/ssh/sshd_config
    
