# This Terraform configuration file sets up an integration between Expel and AWS EKS (Elastic Kubernetes Service).
# It creates an AWS provider, defines variables, and uses a module to configure the integration.

# Variables
variable "region" { type = string }
variable "expel_customer_organization_guid" { type = string }
variable "eks_log_group_name" { type = string }

# AWS provider
provider "aws" { region = var.region }

# Expel AWS EKS integration module
module "expel_aws_eks_integration" {
  source = "../../"
  expel_customer_organization_guid = var.expel_customer_organization_guid
  expel_assume_role_session_name   = "ExpelServiceAssumeRoleForEKSAccess"
  eks_log_group_name               = var.eks_log_group_name
  stream_capacity_mode             = "ON_DEMAND"
  stream_retention_hours           = 24
  enable_stream_encryption         = true
  prefix = "expel-aws-eks"
  tags = { "is_external" = "true" }
}

# Output
output "expel_aws_eks_integration" { value = module.expel_aws_eks_integration }