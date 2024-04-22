/**
 * This file contains the variables used to configure the Kinesis data stream for EKS logs.
 *
 * region:
*   The AWS region in which you want the Kinesis data stream to be configured for EKS logs.
*   Replace with the AWS region in which you want the Kinesis data stream to be configured for EKS logs.
*
* expel_customer_organization_guid:
*   The organization GUID assigned to you by Expel.
*   You can find it in your browser URL after navigating to Settings > My Organization in Workbench.
*   Replace this value with your organization GUID.
*
* eks_log_group_name:
*   The EKS log group name.
*   Replace with the EKS log group name.
*
*/

region                           = "Replace with the AWS region you want the Kinesis data stream to be configured for EKS"
expel_customer_organization_guid = "Replace with your organization GUID assigned to you by Expel. You can find it in your browser URL after navigating to Settings > My Organization in Workbench"
eks_log_group_name               = "Replace with your EKS log group name"
