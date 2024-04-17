# Terraform AWS EKS Integration with Expel

This Terraform module sets up an integration between Expel and Amazon Elastic Kubernetes Service (EKS).

This configuration sets up appropriate AWS resources that are necessary to integrate Expel Workbench with an existing EKS instance.

This `Basic` example is the simplest onboarding experience, as it assumes a single AWS Account is being onboarded with one EKS instance.

## Table of Contents

- [Variables](#variables)
- [Provider](#provider)
- [Module](#module)
- [Output](#output)
- [Usage](#usage)
- [Prerequisites](#prerequisites)

## Variables

To use this module, you need to provide the following variables:

- `region`: The AWS region where the EKS cluster is located.
- `expel_customer_organization_guid`: The organization GUID assigned by Expel. You can find it in your browser URL after navigating to Settings > My Organization in Workbench.
- `eks_log_group_name`: The name of the log group in CloudWatch that contains EKS logs.

## Provider

`aws`: The AWS provider used to create the CloudTrail resources. The region is set based on the value of the "region" variable.

## Module

`expel_aws_eks_integration`: The Expel AWS EKS module.  that sets up the integration between Expel and EKS. It creates the necessary AWS resources to enable the integration.

## Output

`expel_aws_eks_integration`: The output can be used to reference the resources created by the module in other parts of your Terraform configuration.

## Usage

Follow these steps to deploy the configuration:

1. Initialize Terraform in your working directory. This will download the necessary provider plugins.
2. Apply the Terraform configuration. Ensure you have a terraform.tfvars file in your working directory with  all the necessary variables:

```sh
terraform init
terraform apply -var-file="terraform.tfvars"
```

> **Note** that this example may create resources which can cost money (AWS Kinesis data stream, for example). Run `terraform destroy` when you don't need these resources.

## Prerequisites

Ensure you have the following tools installed on your machine:

| Name | Version |
|------|---------|
| terraform | = 1.1.3 |
| aws | = 4.0 |

Refer to the official Terraform documentation and AWS Provider documentation for installation instructions.