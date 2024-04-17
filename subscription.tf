/*
  This Terraform file defines the necessary IAM roles and policies for an AWS EKS cluster.
  It allows CloudWatch to assume a role and put records on a Kinesis stream.

  Resources:
  - aws_iam_policy_document.cloudwatch_assume_role_iam_document: Defines the IAM policy document that allows CloudWatch to assume a role.
  - aws_iam_role.cloudwatch_assume_role: Defines the IAM role that CloudWatch can assume.
  - aws_iam_role_policy_attachment.eks_producer_policy_attachment: Attaches the IAM policy to the IAM role.
  - aws_iam_policy.eks_producer_policy: Defines the IAM policy that allows CloudWatch to put records on the Kinesis stream.
  - data.aws_iam_policy_document.eks_producer_iam_document: Defines the IAM policy document that allows CloudWatch to put records on the Kinesis stream.

  Inputs:
  - var.prefix: The prefix to use for naming the IAM roles and policies.
  - local.region: The AWS region.
  - local.customer_aws_account_id: The AWS account ID.
  - local.tags: The tags to apply to the IAM roles and policies.

  Outputs:
  None

  Usage:
  Include this file in your Terraform project and customize the inputs as needed.
*/

data "aws_iam_policy_document" "cloudwatch_assume_role_iam_document" {
  // Allow CloudWatch to assume the role
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.${local.region}.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:${local.region}:${local.customer_aws_account_id}:*"]
    }
  }
}

resource "aws_iam_role" "cloudwatch_assume_role" {
  name               = "${var.prefix}-cloudwatch-assume-role"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assume_role_iam_document.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "eks_producer_policy_attachment" {
  role       = aws_iam_role.cloudwatch_assume_role.name
  policy_arn = aws_iam_policy.eks_producer_policy.arn
}

resource "aws_iam_policy" "eks_producer_policy" {
  name   = "${var.prefix}-producer-policy"
  policy = data.aws_iam_policy_document.eks_producer_iam_document.json
  tags   = local.tags
}

data "aws_iam_policy_document" "eks_producer_iam_document" {
  # Allow CloudWatch to put records on the Kinesis stream
  statement {
    actions = [
      "kinesis:PutRecord"
    ]
    resources = [aws_kinesis_stream.kinesis_data_stream.arn]
    effect    = "Allow"
  }
}
