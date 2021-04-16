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
  default = "lambda_assume_role_controller"
}

variable "service" {
  type    = string
  default = "lambda.amazonaws.com"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_iam_role" "sts_assume_role_controller" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          # AWS     = "arn:aws:iam::264010607452:user/cicd"
          Service = var.service
        }
        Sid = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2-readonly-role-policy-attach" {
  role       = aws_iam_role.sts_assume_role_controller.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

output "assume_role_arn" {
  value = aws_iam_role.sts_assume_role_controller.arn
}
