

# If encryption was disabled, create an unencrypted stream
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
