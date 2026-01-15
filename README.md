# Terraform – Secure Production-Style AWS Infrastructure

## Project Overview
This project demonstrates a **secure, production-style AWS infrastructure** built using Terraform, following real-world security and operational practices.

The infrastructure is designed with:
- Zero SSH access
- Least-privilege IAM
- Private-by-default networking

The goal is to showcase **how secure AWS infrastructure is actually designed and validated**, not simplified demos.

---

## Architecture Summary

### Network
- Custom VPC: `10.0.0.0/16`
- Public subnets: Application Load Balancer only
- Private subnets: EC2 and RDS
- Internet Gateway attached to public subnets
- NAT Gateway for controlled outbound access
- Private route tables with no direct internet exposure

---

### Compute
- EC2 instance deployed in a private subnet
- No public IP assigned
- Access via **AWS Systems Manager (SSM) only**
- IAM role with least-privilege permissions

---

### Load Balancing
- Internet-facing Application Load Balancer
- Routes traffic only to private EC2 targets
- Security groups restrict traffic strictly from ALB to EC2

---

### Database
- Amazon RDS (MySQL)
- Deployed in private subnets only
- No public access
- Security group allows access only from EC2

---

### Storage
- Private S3 bucket
- Public access fully blocked
- IAM-based access control only

---

### Monitoring
CloudWatch alarms configured for:
- EC2 CPU utilization
- ALB unhealthy target count

---

## Security Design
- No SSH keys
- No inbound access to EC2
- Least-privilege IAM roles
- VPC endpoints for private SSM connectivity
- No hardcoded credentials
- No sensitive outputs or state files committed to Git

---

## Repository Structure
.
├── alb.tf                    # Application Load Balancer
├── cloudwatch.tf             # CloudWatch alarms
├── ec2.tf                    # Private EC2 instance (SSM only)
├── iam.tf                    # Least-privilege IAM roles
├── nat.tf                    # NAT Gateway
├── outputs.tf                # Terraform outputs (no sensitive values)
├── providers.tf              # AWS provider configuration
├── rds.tf                    # Private RDS MySQL
├── s3.tf                     # Private S3 bucket
├── variables.tf              # Input variables
├── vpc.tf                    # VPC, subnets, and routing
├── vpc_endpoints.tf          # VPC endpoints for SSM
└── README.md

yaml
Copy code

---

## Verification Performed
The following validations were completed before destroying the infrastructure:

- ALB successfully routed HTTP traffic to private EC2
- EC2 instance accessible via AWS Systems Manager (no SSH)
- Apache web server running on EC2
- RDS MySQL reachable from EC2
- Database connectivity verified using MySQL client
- CloudWatch alarms triggered and observed
- IAM role permissions validated

Screenshots of these validations are included in the repository.

---

## Infrastructure Lifecycle
- Infrastructure provisioned using Terraform
- Functional and security validation completed
- Evidence documented
- Infrastructure intentionally destroyed to avoid unnecessary cost

This reflects proper **infrastructure lifecycle management**.

---

## Design Principles Followed
- Security by default
- No public EC2 exposure
- Least-privilege IAM
- Private networking
- No credential leakage
- Minimal but production-realistic scope
- Clean Git history with logical commits

---

## Disclaimer
This project is intended for **demonstration and learning purposes**.  
It represents a secure baseline architecture and can be extended for real production workloads.

---

## Author
**Vignesh Gopal**  
Cloud / DevOps Engineer
