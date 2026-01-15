Terraform Secure Production AWS Infrastructure
Overview

This project demonstrates a secure, production-style AWS infrastructure built using Terraform, following real-world security and operational best practices.

The infrastructure is designed with zero SSH access, least-privilege IAM, and private-by-default networking, suitable for enterprise environments.

Architecture Summary

Network

Custom VPC (10.0.0.0/16)

Public subnets (ALB only)

Private subnets (EC2 + RDS)

Internet Gateway (public only)

NAT Gateway for controlled outbound access

Private route tables with no direct internet exposure

Compute

EC2 instance in private subnet

No public IP

Access via AWS Systems Manager (SSM) only

IAM role with least privilege

Load Balancing

Internet-facing Application Load Balancer

Routes traffic only to private EC2

Security groups restrict traffic strictly from ALB to EC2

Database

Amazon RDS (MySQL)

Private subnets only

No public access

Security group allows access only from EC2

Storage

Private S3 bucket

Public access completely blocked

IAM-based access control

Monitoring

CloudWatch alarms for:

EC2 CPU utilization

ALB unhealthy targets

Security

No SSH keys

No inbound access to EC2

Least-privilege IAM roles

VPC endpoints for private SSM connectivity

Repository Structure
.
├── alb.tf              # Application Load Balancer
├── cloudwatch.tf       # CloudWatch alarms
├── ec2.tf              # Private EC2 instance (SSM only)
├── iam.tf              # Least-privilege IAM roles
├── nat.tf              # NAT Gateway
├── outputs.tf          # Terraform outputs (not committed with values)
├── providers.tf        # AWS provider configuration
├── rds.tf              # Private RDS MySQL
├── s3.tf               # Private S3 bucket
├── variables.tf        # Input variables
├── vpc.tf              # VPC, subnets, routing
├── vpc_endpoints.tf    # VPC endpoints for SSM
└── README.md

Verification Performed

The following validations were completed before destroying the infrastructure:

ALB successfully routed HTTP traffic to private EC2

EC2 instance reachable via AWS Systems Manager (no SSH)

Apache web server running on EC2

RDS MySQL instance reachable from EC2

Database connectivity verified using MySQL client

CloudWatch alarms triggered and observed

IAM role permissions validated

Screenshots of these validations are included in the repository.

Infrastructure Lifecycle

Infrastructure was deployed using Terraform

Functional validation was completed

Evidence was documented

Infrastructure was intentionally destroyed to avoid unnecessary cost

This reflects proper infrastructure lifecycle management.

Design Principles Followed

Security by default

No public EC2 exposure

No hardcoded credentials

No state files or sensitive outputs committed

Minimal but production-realistic scope

Clean Git history with logical commits

Disclaimer

This project is intended for demonstration and learning purposes.
It represents a secure baseline architecture and can be extended for real production workloads.

Author

Vignesh Gopal
Cloud / DevOps Engineer
