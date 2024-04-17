# This resource block defines an AWS CloudWatch Log Subscription Filter for an Amazon EKS cluster.
# It forwards log events from the specified log group to a Kinesis Data Stream.
# The `name` attribute specifies the name of the subscription filter.
# The `role_arn` attribute specifies the ARN of the IAM role that grants permission to CloudWatch Logs to deliver log events to the destination.
# The `log_group_name` attribute specifies the name of the log group from which to stream log events.
# The `filter_pattern` attribute specifies a filter pattern to use for filtering log events.
# The `destination_arn` attribute specifies the ARN of the Kinesis Data Stream to which to deliver log events.
# The `distribution` attribute specifies the distribution of log events across the destination shards.

resource "aws_cloudwatch_log_subscription_filter" "eks_subscription_filter" {
  name            = "${var.prefix}-subscription-filter"
  role_arn        = aws_iam_role.cloudwatch_assume_role.arn
  log_group_name  = var.eks_log_group_name
  filter_pattern  = ""
  destination_arn = aws_kinesis_stream.kinesis_data_stream.arn
  distribution    = "Random"
}

