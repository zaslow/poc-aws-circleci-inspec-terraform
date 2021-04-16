#!/bin/bash

terraform -chdir=./tf init && \
terraform -chdir=./tf apply -auto-approve && \
assume_role_arn=$(terraform -chdir=./tf output -json | jq -r ".assume_role_arn.value")

export TEMP_ROLE=`aws sts assume-role --role-arn "${assume_role_arn}" --role-session-name docker-compose`
export AWS_ACCESS_KEY_ID=$(echo "${TEMP_ROLE}" | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(echo "${TEMP_ROLE}" | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(echo "${TEMP_ROLE}" | jq -r ".Credentials.SessionToken")

inspec exec --chef-license accept-silent . -t aws://
