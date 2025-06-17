#!/bin/bash

# Define account variables
ACCOUNT_A_ID="123456789012"  # Replace with your account-a ID
ACCOUNT_B_ID="987654321012"  # Replace with your account-b ID

# Step 1: Create the target IAM role in account-b with Bedrock full access
echo "Creating target IAM role in account-b..."
aws iam create-role \
  --role-name eks-pod-identity-bedrock-role \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }' \
  --description "Target IAM role for EKS Pod Identity to access Bedrock" \
  --profile account-b

# Step 2: Attach Bedrock full access policy to the target role
echo "Attaching Bedrock full access policy to target role..."
aws iam attach-role-policy \
  --role-name eks-pod-identity-bedrock-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonBedrockFullAccess \
  --profile account-b

# Step 3: Update the trust policy of the target role to allow the EKS Pod Identity role to assume it
echo "Updating trust policy of target role..."
aws iam update-assume-role-policy \
  --role-name eks-pod-identity-bedrock-role \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::'${ACCOUNT_A_ID}':root"
        },
        "Action": "sts:AssumeRole"
      },
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::'${ACCOUNT_A_ID}':root"
        },
        "Action": "sts:TagSession"
      }
    ]
  }' \
  --profile account-b

# Step 4: Create the EKS Pod Identity role in account-a
echo "Creating EKS Pod Identity role in account-a..."
aws iam create-role \
  --role-name eks-pod-identity-primary-role \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "pods.eks.amazonaws.com"
        },
        "Action": [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  }' \
  --description "EKS Pod Identity role to assume target role for Bedrock access" \
  --profile account-a

# Step 5: Create an inline policy for the EKS Pod Identity role to allow it to assume the target role
echo "Creating inline policy for EKS Pod Identity role..."
aws iam put-role-policy \
  --role-name eks-pod-identity-primary-role \
  --policy-name AssumeTargetRolePolicy \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "sts:AssumeRole",
          "sts:TagSession"
        ],
        "Resource": "arn:aws:iam::'${ACCOUNT_B_ID}':role/eks-pod-identity-bedrock-role"
      }
    ]
  }' \
  --profile account-a

echo "IAM role setup complete!"
echo "Target IAM role ARN: arn:aws:iam::${ACCOUNT_B_ID}:role/eks-pod-identity-bedrock-role"
echo "EKS Pod Identity role ARN: arn:aws:iam::${ACCOUNT_A_ID}:role/eks-pod-identity-primary-role"
