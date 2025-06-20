# 🚀 ECS-TERRA: Terraform 3-Tier Application Deployment

This project provisions a **highly-available 3-tier architecture** on AWS using **Terraform modules**. It includes front-end, back-end, and database layers, along with networking and security configurations.

## 📦 Architecture Overview

- **Frontend:** Deployed in ECS Fargate, exposed via a public ALB.
- **Backend:** Communicates with frontend through an internal ALB.
- **Database:** RDS instance in private subnet with credentials from AWS Secrets Manager.
- **Networking:** 5 subnets (3 public, 2 private) across multiple AZs.
- **Container Registry:** Docker image is built and pushed to Amazon ECR.
- **IAM Roles:** Configured for ECS tasks and services using least privilege.

