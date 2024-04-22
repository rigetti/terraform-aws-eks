# Terraform AWS EKS

This Terraform module is designed to configure Amazon Elastic Kubernetes Service (EKS) to integrate with [Expel Workbench](https://workbench.expel.io/). The module sets up a CloudWatch subscription filter to send data to a Kinesis data stream, which is then consumed by Expel Workbench.

> :exclamation: Terraform state may contain sensitive information. Please follow best security practices when securing your state.

## Table of Contents

- [Features](#features)
- [Usage](#usage)
- [Enabling k8s API Read-Only Access](#enabling-k8s-api-read-only-access)
  - [Using `eksctl`](#1-using-eksctl)
  - [Using Terraform](#2-using-terraform)
- [AWS Documentation](#aws-documentation)
- [Finishing Steps](#finishing-steps)
- [Permissions](#permissions)
- [Example](#example)
- [Limitations](#limitations)
- [Requirements](#requirements)
- [Providers](#providers)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Resources](#resources)
- [Contributing](wip.CONTRIBUTING.md)

## Features

This Terraform module offers the following features:

- **Amazon EKS Integration**: Seamlessly integrates your Amazon EKS setup with Expel Workbench for enhanced security monitoring.
- **CloudWatch Subscription Filter**: Automatically configures a CloudWatch subscription filter to send data to a Kinesis data stream.
- **Kinesis Data Stream**: Sets up a Kinesis data stream that is consumed by Expel Workbench, providing real-time data for security monitoring.
- **Kubernetes API Read-Only Access**: Provides instructions for enabling read-only access to the Kubernetes API, either through `eksctl` or directly through Terraform.
- **AWS Documentation**: Links to the full AWS documentation for additional guidance and support.
- **Security Device Setup**: Guides you through the process of creating an AWS EKS security device on Expel Workbench to start monitoring your AWS environment.
- **Permissions**: Allocates permissions that allow Expel Workbench to perform investigations and gain a broad understanding of your AWS footprint.
- **Limitations**: Clearly outlines the limitations of the module, such as only supporting the onboarding of a single AWS account and always creating a new CloudWatch subscription filter and Kinesis data stream.

## Usage

The use this module in a Terraform Script, users need to replace certain placeholders with their specific values, such as their organization's GUID from Expel Workbench, the AWS region where the Kinesis data stream will be created, and the log group name for EKS logs.

```hcl
module "expel_aws_eks" {
  source  = "expel-io/k8s-control-plane/aws"
  version = "1.1.0"

  expel_customer_organization_guid = "Replace with your organization GUID from Expel Workbench"
  region = "AWS region in which Kinesis data stream will be created"
  eks_log_group_name = "The log group name for EKS logs to integration with Expel Workbench"
}
```

### Enabling k8s API read only access

This module does not map the Expel ARN to the kubernetes `expel-user` (necessary for our Benchmark Report). This requires modifying the `aws-auth` config map either through `eksctl` or terraform.

### 1. Using `eksctl`

`eksctl` can update this map for you by running:

``` shell
eksctl create iamidentitymapping \
    --cluster <your-cluster-name> \
    --region <your-region> \
    --arn <your-expel-role-arn> \
    --username expel-user
```

You can confirm the mapping is created by running:

``` shell
eksctl get iamidentitymapping --cluster <your-cluster-name> --region <your-region>
```

### 2. Using terraform

If you are using the official [EKS AWS module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest) you can update this with your existing EKS module

``` hcl
module "eks" {
  [...]

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = <your-expel-role-arn>
      username = "expel-user"
      groups   = []
    },
  ]
```

### AWS Documentation

You can find the full AWS documentation [here](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html).

### Validating mapping configuration

Once completed you can confirm the mapping is created by running:

``` shell
eksctl get iamidentitymapping --cluster <your-cluster-name> --region <your-region>
```

### Finishing steps

Once you have configured your AWS environment, go to
[https://workbench.expel.io/settings/security-devices?setupIntegration=kubernetes_eks](https://workbench.expel.io/settings/security-devices?setupIntegration=kubernetes_eks) and create an AWS EKS security device to enable Expel to begin monitoring your AWS environment.

## Permissions

The permissions allocated by this module allow Expel Workbench to perform investigations and get a broad understanding of your AWS footprint.

## Example

You can find an example of how to use this module in the [examples](examples) directory.

## Limitations

1. Only supports onboarding a single AWS account, not an entire AWS Organization.
2. Will always create a new CloudWatch subscription filter (AWS has a limit of 2 subscription filters per CloudWatch log group)
3. Will always create a new Kinesis data stream.

See Expel's Getting Started Guide for Amazon EKS for options if you
have an AWS Organization or already have a Kinesis data stream you want to re-use.

## Issues

Found a bug or have an idea for a new feature? Please [create an issue](https://github.com/expel-io/terraform-aws-eks/issues). We'll respond as soon as possible!

## Contributing

We welcome contributions! Here's how you can help:

1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the Branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

Please read our [Contributing Code of Conduct](CONTRIBUTING.md) to get started.

<!-- begin-tf-docs -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.9.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_log_group_name"></a> [eks\_log\_group\_name](#input\_eks\_log\_group\_name) | The EKS log group name to integrate with Expel Workbench. | `string` | n/a | yes |
| <a name="input_expel_customer_organization_guid"></a> [expel\_customer\_organization\_guid](#input\_expel\_customer\_organization\_guid) | Expel customer's organization GUID assigned to you by Expel. You can find it in your browser URL after navigating to Settings > My Organization in Workbench. | `string` | n/a | yes |
| <a name="input_enable_stream_encryption"></a> [enable\_stream\_encryption](#input\_enable\_stream\_encryption) | Optionally encrypt data in the Kinesis stream with a Kinesis-owned KMS key. | `bool` | `true` | no |
| <a name="input_expel_assume_role_session_name"></a> [expel\_assume\_role\_session\_name](#input\_expel\_assume\_role\_session\_name) | The session name Expel will use when authenticating. | `string` | `"ExpelEKSServiceSession"` | no |
| <a name="input_expel_aws_account_arn"></a> [expel\_aws\_account\_arn](#input\_expel\_aws\_account\_arn) | Expel's AWS Account ARN to allow assuming role to gain EKS access. | `string` | `"arn:aws:iam::012205512454:user/ExpelCloudService"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A prefix to group all Expel integration resources. | `string` | `"expel-aws-eks"` | no |
| <a name="input_stream_capacity_mode"></a> [stream\_capacity\_mode](#input\_stream\_capacity\_mode) | The data stream capacity mode: ON\_DEMAND (recommended) or PROVISIONED. See: https://docs.aws.amazon.com/streams/latest/dev/how-do-i-size-a-stream.html | `string` | `"ON_DEMAND"` | no |
| <a name="input_stream_retention_hours"></a> [stream\_retention\_hours](#input\_stream\_retention\_hours) | The number of hours data will be retained in the stream. See: https://docs.aws.amazon.com/streams/latest/dev/kinesis-extended-retention.html | `number` | `24` | no |
| <a name="input_stream_shard_count"></a> [stream\_shard\_count](#input\_stream\_shard\_count) | The number of shards for the Kinesis stream. Only required if `stream_capacity_mode` is `PROVISIONED`. See: https://docs.aws.amazon.com/streams/latest/dev/how-do-i-size-a-stream.html | `number` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A set of tags to group resources. | `map` | `{}` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | The AWS Region where the Kinesis resources exist |
| <a name="output_kinesis_stream_name"></a> [kinesis\_stream\_name](#output\_kinesis\_stream\_name) | Name of the Kinesis data stream Expel will consume from |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | IAM Role ARN of the role for Expel to assume to access Kinesis data |
| <a name="output_role_session_name"></a> [role\_session\_name](#output\_role\_session\_name) | The session name Expel will use when authenticating |
## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_subscription_filter.eks_subscription_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_iam_policy.eks_consumer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eks_producer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cloudwatch_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.expel_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_consumer_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_producer_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kinesis_stream.kinesis_data_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_iam_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch_assume_role_iam_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_consumer_iam_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_producer_iam_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
<!-- end-tf-docs -->