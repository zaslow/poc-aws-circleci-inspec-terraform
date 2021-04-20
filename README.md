# CircleCI, Inspec, & Terraform POC on AWS
**Provision permissions with Terraform on AWS & run Chef Inspec compliance tests via CircleCI**

## Pre-requisites
Create an AWS IAM user with the following basic permissions set to `Allow`
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
