
data "aws_iam_policy_document" "cloudwatch_assume_role_iam_document" {
  # Allow CloudWatch to assume the role
  statement {
    actions       = ["sts:AssumeRole"]
    effect        = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.${local.region}.amazonaws.com"]
    }

    condition {
      test        = "StringLike"
      variable    = "aws:SourceArn"
      values      = ["arn:aws:logs:${local.region}:${local.customer_aws_account_id}:*"]
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
    actions   = [
      "kinesis:PutRecord"
    ]
    resources = [aws_kinesis_stream.kinesis_data_stream.arn]
    effect    = "Allow"
  }
}


