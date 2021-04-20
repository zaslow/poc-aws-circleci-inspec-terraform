#!/bin/bash

get_terraform_output() {
  echo $(terraform -chdir=./tf output -json | jq -r $1)
}

terraform -chdir=./tf init
terraform -chdir=./tf apply \
  -auto-approve \
  -var region=$AWS_REGION \
  -var user_arn=$(aws sts get-caller-identity --output json | jq -r '.Arn')

assume_role_arn=$(get_terraform_output '.assume_role_arn.value') 
assume_role_name=$(get_terraform_output '.assume_role_name.value')

# ToDo; Figure out why sts:AssumeRole returns AccessDenied immediately after creating role
echo 'Waiting for role to be assumable'
sleep 10

export TEMP_ROLE=`aws sts assume-role \
  --output json \
  --role-arn "${assume_role_arn}" \
  --role-session-name docker-compose`
export AWS_ACCESS_KEY_ID=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "${TEMP_ROLE}" | jq -r '.Credentials.SessionToken')

inspec exec --chef-license accept-silent . -t aws://
