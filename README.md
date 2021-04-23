# CircleCI, InSpec, & Terraform POC on AWS
**Provision permissions with Terraform on AWS & run Chef Inspec compliance tests via CircleCI**

Given an AWS IAM user, this project will use Terraform to provision a new IAM role with policy-based permissions and then run Chef InSpec compliance tests against the given AWS instance. This is orchestrated both locally with Docker Compose, and remotely with CircleCI.

## Pre-requisites
Create an AWS IAM user with the following basic permissions (basically all policy & role permissions, plus `sts:AssumeRole`) set to `Allow`
```
iam:GetRole
iam:GetRolePolicy
iam:ListRoles
iam:ListRolePolicies
iam:CreateRole
iam:DeleteRole
iam:DeleteRolePolicy
iam:DetachRolePolicy
iam:GetPolicy
iam:GetPolicyVersion
iam:ListPolicyVersions
iam:CreatePolicy
iam:CreatePolicyVersion
iam:DeletePolicy
iam:DeletePolicyVersion
iam:AttachRolePolicy
iam:ListAttachedRolePolicies
iam:ListEntitiesForPolicy
iam:ListInstanceProfilesForRole
iam:SetDefaultPolicyVersion
iam:UpdateAssumeRolePolicy
sts:AssumeRole
```
--
## Run Inspec tests locally

### Setup
Export the following environment variables for your user
```
AWS_REGION
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

### Run
```
docker-compose up
```
The terraform potion must be run locally - this simplifies TF state management. In a team context, the `terraform.tfstate` file would be stored in a shared location such as AWS S3.

You can customize the name of the AWS profile or role you are using by changing the values in `tf/main.tfvars.json`.
--
## CircleCI

### Setup
Set the following environment variables in your CircleCI project settings:
```
AWS_REGION
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```
Install CircleCI CLI (for local only): https://circleci.com/docs/2.0/local-cli/

### Run (local)
```
circleci local execute \
  -e AWS_REGION=$AWS_REGION \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  --job run_inspec
```

### Run (remote)
The pipeline will run the tests on every commit that is pushed to your remote repo.
