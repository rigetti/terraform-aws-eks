
resource "aws_cloudwatch_log_subscription_filter" "eks_subscription_filter" {
  name            = "${var.prefix}-subscription-filter"
  role_arn        = aws_iam_role.cloudwatch_assume_role.arn
  log_group_name  = var.eks_log_group_name
  filter_pattern  = ""
  destination_arn = aws_kinesis_stream.kinesis_data_stream.arn
  distribution    = "Random"
}
