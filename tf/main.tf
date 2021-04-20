terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

variable "profile" {
  type    = string
  default = "cicd"
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "role_name" {
  type    = string
  default = "ComplianceTestsController"
}

variable "user_arn" {
  type    = string
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_iam_role" "compliance_tests_controller" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        AWS     = var.user_arn
      }
      Sid       = ""
    }]
  })
}

resource "aws_iam_policy" "compliance_tests_policy" {
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Action   = ["ec2:DescribeRegions"]
      Effect   = "Allow"
      Resource = "*"
    }]
  })  
}

resource "aws_iam_role_policy_attachment" "compliance_tests_controller_policy" {
  role       = aws_iam_role.compliance_tests_controller.name
  policy_arn = aws_iam_policy.compliance_tests_policy.arn
}

output "assume_role_arn" {
  value = aws_iam_role.compliance_tests_controller.arn
}

output "assume_role_name" {
  value = aws_iam_role.compliance_tests_controller.name
}
