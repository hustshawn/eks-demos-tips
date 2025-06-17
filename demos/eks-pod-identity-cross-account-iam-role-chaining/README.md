# Cross-Account Bedrock Access with EKS Pod Identity

This guide demonstrates how to set up cross-account access to Amazon Bedrock using EKS Pod Identity.

## Setup Overview

1. Created a target IAM role in account-b (ACCOUNT-B-ID) with Bedrock full access
2. Created an EKS Pod Identity role in account-a (ACCOUNT-A-ID) that can assume the target role
3. Set up the necessary trust relationships between the roles
4. Created Kubernetes resources and Pod Identity association

## IAM Roles

### Target IAM Role (in account-b)
- **Role Name**: eks-pod-identity-bedrock-role
- **ARN**: arn:aws:iam::ACCOUNT-B-ID:role/eks-pod-identity-bedrock-role
- **Permissions**: AmazonBedrockFullAccess
- **Trust Policy**: Allows the EKS Pod Identity role from the default account to assume this role

### EKS Pod Identity Role (in default account)
- **Role Name**: eks-pod-identity-primary-role
- **ARN**: arn:aws:iam::ACCOUNT-A-ID:role/eks-pod-identity-primary-role
- **Trust Policy**: Allows the EKS Pod Identity service to assume this role
- **Inline Policy**: Allows this role to assume the target role in account-b

## Kubernetes Resources

- **Namespace**: bedrock-app
- **Service Account**: bedrock-service-account
- **Pod Identity Association**: Links the service account to the EKS Pod Identity role

## Usage

1. Run the setup script to create the Pod Identity association:
   ```bash
   ./create-pod-identity-association.sh
   ```

2. Test Bedrock access from a pod:
   ```bash
   ./test-bedrock-access.sh
   ```

## How It Works

1. When a pod using the `bedrock-service-account` service account makes an AWS API call:
   - The EKS Pod Identity Agent intercepts the call
   - It first assumes the EKS Pod Identity role (eks-pod-identity-primary-role)
   - Then it uses those credentials to assume the target role (eks-pod-identity-bedrock-role)
   - The pod receives temporary credentials with Bedrock access permissions

2. The AWS SDK in the pod automatically uses these credentials to make Bedrock API calls

## Troubleshooting

If you encounter issues:

1. Check that the EKS Pod Identity Agent is installed on your cluster:
   ```bash
   kubectl get daemonset -n kube-system eks-pod-identity-agent
   ```

2. Verify the Pod Identity association:
   ```bash
   aws eks list-pod-identity-associations --cluster-name cluster-1-32 --region us-west-2
   ```

3. Check pod logs for credential issues:
   ```bash
   kubectl logs bedrock-test-pod -n bedrock-app
   ```

4. Verify IAM role trust relationships and permissions in both accounts
