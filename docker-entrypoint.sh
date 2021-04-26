#!/bin/bash

role_name=$(cat ./tf/main.tfvars.json | jq -r '.role_name')
role_cmd='aws iam get-role --role-name $role_name --output'
eval "${role_cmd} text"

until [ $? -eq 0 ]; do
  echo 'Waiting for resources to be provisioned.'
  sleep 1
  eval "${role_cmd} text"
done

# ToDo; Figure out why sts:AssumeRole returns AccessDenied immediately after creating role
echo 'Waiting for role to be assumable'
sleep 10

temp_role=`aws sts assume-role \
  --output json \
  --role-arn $(eval "${role_cmd} json | jq -r '.Role.Arn'") \
  --role-session-name assume-role-session`
export AWS_ACCESS_KEY_ID=$(echo "${temp_role}" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "${temp_role}" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "${temp_role}" | jq -r '.Credentials.SessionToken')

inspec vendor --overwrite --chef-license accept-silent && \
  inspec exec --chef-license accept-silent . -t aws://
