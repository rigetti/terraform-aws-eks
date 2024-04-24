/**
 * This Terraform configuration file sets up the required providers and version constraints,
 * and defines data sources and local variables.
 *
 * Providers:
 * - AWS: The AWS provider is required for managing AWS resources.
 *
 * Version Constraints:
 * - Terraform: The minimum required version of Terraform is 1.1.0.
 * - AWS Provider: The minimum required version of the AWS provider is 4.0.0.
 *
 * Data Sources:
 * - aws_region: Retrieves the current AWS region.
 * - aws_caller_identity: Retrieves the current AWS caller identity.
 *
 * Local Variables:
 * - default_tags: A map of default tags, with the "vendor" tag set to "expel".
 * - tags: Merges the variable tags with the default_tags, providing a final set of tags.
 * - region: The name of the current AWS region.
 * - customer_aws_account_id: The AWS account ID of the current caller identity.
 */
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.1.0"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  default_tags = {
    "vendor" = "expel"
  }

  tags = merge(
    var.tags,
    local.default_tags,
  )

  region                  = data.aws_region.current.name
  customer_aws_account_id = data.aws_caller_identity.current.account_id
}
