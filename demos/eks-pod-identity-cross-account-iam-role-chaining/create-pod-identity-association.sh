#!/bin/bash

# Define account variables
ACCOUNT_A_ID="123456789012"  # Replace with your account-a ID
ACCOUNT_B_ID="987654321012"  # Replace with your account-b ID
CLUSTER_NAME="my-cluster"  # Replace with your cluster name
REGION="us-west-2"           # Replace with your region

# Apply the service account
kubectl apply -f bedrock-service-account.yaml

# Create the Pod Identity association
aws eks create-pod-identity-association \
  --cluster-name ${CLUSTER_NAME} \
  --namespace bedrock-app \
  --service-account bedrock-service-account \
  --role-arn arn:aws:iam::${ACCOUNT_A_ID}:role/eks-pod-identity-primary-role \
  --target-role-arn arn:aws:iam::${ACCOUNT_B_ID}:role/eks-pod-identity-bedrock-role \
  --region ${REGION}

# Verify the Pod Identity association
aws eks list-pod-identity-associations \
  --cluster-name ${CLUSTER_NAME} \
  --region ${REGION}
