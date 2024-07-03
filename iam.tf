# This Terraform file defines IAM roles and policies for an AWS EKS cluster.

# This data block defines an IAM policy document that allows Expel to assume the role.
data "aws_iam_policy_document" "assume_role_iam_document" {
  # Allow Expel to assume the role
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.expel_aws_account_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.expel_customer_organization_guid]
    }
  }
}

# This resource block defines an IAM role for Expel to assume.
resource "aws_iam_role" "expel_assume_role" {
  name               = "${var.prefix}-ExpelServiceAssumeRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_iam_document.json
  tags               = local.tags
}

# This resource block attaches an IAM policy to the Expel assume role.
resource "aws_iam_role_policy_attachment" "eks_consumer_policy_attachment" {
  role       = aws_iam_role.expel_assume_role.name
  policy_arn = aws_iam_policy.eks_consumer_policy.arn
}

# This resource block defines an IAM policy for Expel to access and manage EKS resources.
resource "aws_iam_policy" "eks_consumer_policy" {
  name   = "${var.prefix}-eks-consumer-policy"
  policy = data.aws_iam_policy_document.eks_consumer_iam_document.json
  tags   = local.tags
}

# This data block defines an IAM policy document that allows Expel Workbench to access and manage Kinesis and EKS resources.
# Note: The policies with wildcards are ignored by tfsec.
#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "eks_consumer_iam_document" {

  # Allow Expel Workbench to retrieve data from Kinesis
  statement {
    actions = [
      "kinesis:DescribeLimits",
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:ListShards"
    ]
    resources = [aws_kinesis_stream.kinesis_data_stream.arn]
    effect    = "Allow"
  }

  # Allow Expel Workbench to gather information about EKS clusters
  statement {
    actions = [
      "eks:AccessKubernetesApi",
      "eks:DescribeCluster",
      "eks:DescribeNodegroup",
      "eks:ListClusters",
      "eks:ListNodegroups",
      "eks:ListUpdates",
      "sts:GetCallerIdentity",
      "ec2:DescribeRegions",
      "autoscaling:DescribeAutoScalingGroups"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}
