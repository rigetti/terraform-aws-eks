/**
 * Outputs
 * -------
 * This Terraform file defines the outputs for the AWS EKS cluster module.
 * These outputs provide information about the resources created by the module.
 */

# IAM Role ARN
output "role_arn" {
  description = "IAM Role ARN of the role for Expel to assume to access Kinesis data"
  value       = aws_iam_role.expel_assume_role.arn
}


# Role Session Name
output "role_session_name" {
  description = "The session name Expel will use when authenticating"
  value       = var.expel_assume_role_session_name
}

# AWS Region
output "aws_region" {
  description = "The AWS Region where the Kinesis resources exist"
  value       = local.region
}


#Kinesis Stream Name
output "kinesis_stream_name" {
  description = "Name of the Kinesis data stream Expel will consume from"
  value       = aws_kinesis_stream.kinesis_data_stream.name
}
