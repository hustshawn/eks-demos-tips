# EKS Demos and Tips

A collection of practical demonstrations, tips, and best practices for Amazon Elastic Kubernetes Service (EKS).

## Overview

This repository contains working examples, configuration templates, and step-by-step guides for common EKS scenarios. Each demo is organized in its own directory with detailed documentation.

## Demos

### Available Demos

- [EKS Pod Identity with Cross-Account IAM Role Chaining](./eks-pod-identity-cross-account-iam-role-chaining/README.md) - Demonstrates how to configure EKS Pod Identity to access resources across AWS accounts using IAM role chaining.

### Coming Soon

- EKS Cluster Autoscaling
- EKS Networking Best Practices
- EKS Security Hardening
- EKS Observability Setup
- EKS GitOps with Flux/ArgoCD

## Prerequisites

- AWS CLI configured with appropriate permissions
- kubectl installed
- eksctl installed (for some demos)
- Terraform (for demos using Terraform)
- Docker (for building and testing container images)

## Usage

Each demo directory contains its own README with specific instructions. Generally, you'll follow these steps:

1. Navigate to the demo directory
2. Review the README.md file
3. Follow the step-by-step instructions
4. Clean up resources when finished

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-demo`)
3. Commit your changes (`git commit -m 'Add some amazing demo'`)
4. Push to the branch (`git push origin feature/amazing-demo`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- AWS Documentation
- Kubernetes Community
- Contributors to this repository
