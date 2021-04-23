#!/bin/bash

terraform init
terraform apply \
  -auto-approve \
  -var region=$AWS_REGION \
  -var user_arn=$(aws sts get-caller-identity --output json | jq -r '.Arn')
