variable "expel_customer_organization_guid" {
  description = "Expel customer's organization GUID assigned to you by Expel. You can find it in your browser URL after navigating to Settings > My Organization in Workbench."
  type        = string
}

variable "expel_aws_account_arn" {
  description = "Expel's AWS Account ARN to allow assuming role to gain EKS access."
  type        = string
  default     = "arn:aws:iam::012205512454:user/ExpelCloudService"
}

variable "expel_assume_role_session_name" {
  description = "The session name Expel will use when authenticating."
  type        = string
  default     = "ExpelEKSServiceSession"
}

variable "prefix" {
  description = "A prefix to group all Expel integration resources."
  type        = string
  default     = "expel-aws-eks"

  validation {
    condition     = length(var.prefix) <= 26
    error_message = "Prefix value must be 26 characters or less."
  }
}

variable "tags" {
  description = "A set of tags to group resources."
  default     = {}
}

variable "eks_log_group_name" {
  description = "The EKS log group name to integrate with Expel Workbench."
  type        = string
}

variable "stream_capacity_mode" {
  description = "The data stream capacity mode: ON_DEMAND (recommended) or PROVISIONED. See: https://docs.aws.amazon.com/streams/latest/dev/how-do-i-size-a-stream.html"
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = var.stream_capacity_mode == "ON_DEMAND" || var.stream_capacity_mode == "PROVISIONED"
    error_message = "Stream capacity mode must be one of ON_DEMAND, PROVISIONED."
  }
}

variable "stream_shard_count" {
  description = "The number of shards for the Kinesis stream. Only required if `stream_capacity_mode` is `PROVISIONED`. See: https://docs.aws.amazon.com/streams/latest/dev/how-do-i-size-a-stream.html"
  type        = number
  nullable    = true
  default     = null
}

variable "stream_retention_hours" {
  description = "The number of hours data will be retained in the stream. See: https://docs.aws.amazon.com/streams/latest/dev/kinesis-extended-retention.html"
  type        = number
  default     = 1
}

variable "enable_stream_encryption" {
  description = "Optionally encrypt data in the Kinesis stream with a Kinesis-owned KMS key."
  type        = bool
  default     = true
}
