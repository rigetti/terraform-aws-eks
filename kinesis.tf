# This Terraform configuration creates an AWS Kinesis Data Stream.
# The Kinesis Data Stream can be encrypted using AWS Key Management Service (KMS) or left unencrypted.
# The configuration allows for specifying the retention period, shard level metrics, stream capacity mode, and shard count.
# Tags can also be added to the Kinesis Data Stream for better organization and management.

# Resource: aws_kinesis_stream.kinesis_data_stream
#   - name: The name of the Kinesis Data Stream.
#   - retention_period: The number of hours to retain data records in the stream.
#   - shard_level_metrics: The shard level metrics to enable for the stream.
#   - stream_mode_details: The details of the stream mode, including the capacity mode.
#   - shard_count: The number of shards to create for the stream (only applicable in PROVISIONED capacity mode).
#   - encryption_type: The type of encryption to use for the stream (KMS or NONE).
#   - kms_key_id: The KMS key ID to use for encryption (only applicable if encryption_type is set to KMS).
#   - tags: Tags to assign to the Kinesis Data Stream.

resource "aws_kinesis_stream" "kinesis_data_stream" {
  name             = "${var.prefix}-kinesis-data-stream"
  retention_period = var.stream_retention_hours

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
    "IncomingRecords",
    "OutgoingRecords",
    "IteratorAgeMilliseconds",
  ]

  stream_mode_details {
    stream_mode = var.stream_capacity_mode
  }
  shard_count = var.stream_capacity_mode == "PROVISIONED" ? var.stream_shard_count : null

  # Optionally configure stream encryption
  encryption_type = var.enable_stream_encryption ? "KMS" : "NONE"
  kms_key_id      = var.enable_stream_encryption ? "alias/aws/kinesis" : null

  tags = local.tags
}
