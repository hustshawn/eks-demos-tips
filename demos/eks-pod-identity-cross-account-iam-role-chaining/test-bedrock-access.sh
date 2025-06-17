#!/bin/bash

# Define variables
BEDROCK_REGION="us-east-1"  # Region where Bedrock is available

# Apply the test pod
kubectl apply -f bedrock-test-pod.yaml

# Wait for the pod to be running
echo "Waiting for pod to be running..."
kubectl wait --for=condition=Ready pod/bedrock-test-pod -n bedrock-app --timeout=60s

# Test Bedrock access
echo "Testing Bedrock access from the pod..."
kubectl exec -it bedrock-test-pod -n bedrock-app -- aws bedrock list-foundation-models --region ${BEDROCK_REGION}

# If you want to test a specific Bedrock model
# kubectl exec -it bedrock-test-pod -n bedrock-app -- aws bedrock-runtime invoke-model \
#   --model-id anthropic.claude-v2 \
#   --body '{"prompt": "Human: Hello, Claude! Assistant:", "max_tokens_to_sample": 300}' \
#   --cli-binary-format raw-in-base64-out \
#   --region ${BEDROCK_REGION} \
#   /tmp/output.json

# kubectl exec -it bedrock-test-pod -n bedrock-app -- cat /tmp/output.json
