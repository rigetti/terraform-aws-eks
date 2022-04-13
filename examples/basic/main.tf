variable "region" {
  type = string
}

variable "expel_customer_organization_guid" {
  description = "Use your organization GUID assigned to you by Expel. You can find it in your browser URL after navigating to Settings > My Organization in Workbench"
  type        = string
}

variable "eks_log_group_name" {
  description = "Use the log group name in CloudWatch containing EKS logs."
  type        = string
}

provider "aws" {
  region = var.region
}

module "expel_aws_eks_integration" {
  source = "../../"

  expel_customer_organization_guid = var.expel_customer_organization_guid
  expel_assume_role_session_name   = "ExpelServiceAssumeRoleForEKSAccess"
  eks_log_group_name = var.eks_log_group_name
  stream_capacity_mode = "ON_DEMAND"
  stream_retention_hours = 24
  enable_stream_encryption = true

  prefix = "expel-aws-eks"
  tags = {
    "is_external" = "true"
  }
}

output "expel_aws_eks_integration" {
  value = module.expel_aws_eks_integration
}
