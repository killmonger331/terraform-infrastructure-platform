# Platform Overview

This platform is designed to deploy a secure, highly available, and scalable web app on AWS. It includes a VPC with public and private subnets across multiple AZs, an ALB, EC2 instances in an ASG, an RDS database in private subnets, and supporting AWS services for security, monitoring and storage. 

## Architectual Diagram

![AWS-Architecture](docs/screenshots/AWS-Architecture.png)

The platform separates the public application entry point, private comput resources, and database tier across multiple Availability Zones. 

### Core Architecture

- Amazon VPC
- Two Availability Zones
- Public subnets
- Private application Subnets
- Private database subnets
- Internet Gateway
- NAT Gateways
- Application Load Balancer
- EC2 Auto Scaling Group
- Amazon RDS Multi-AZ
- Security Groups
- Amazon CloudWatch dashboards and alarms
- Amazon S3
- Amazon CloudFront
- Terraform remote state in S3
- GitHub Actions CI/CD
- GitHub OIDC authentication to AWS

## What This Platform Demonstrates

This project demonstrates the ability to design, automate, deploy and manage AWS infrastructure using modern Infrastructure-as-Code and DevOps practices.

### Infrastructure as Code

All AWS infrastructure is defined using Terraform rather than manually created through the AWS Management Console.

Terraform manages:

- Networking
- Subnets
- Routing
- Security groups
- Load balancing
- Auto Scaling
- EC2 compute
- RDS
- CloudWatch monitoring
- Frontend hosting infrastructure
- IAM/OIDC integration
- Remote Terraform state

### Modular Terraform Design

Infrastructure is separated into reusable Terraform modules so the same architecture can be deployed into multiple environments without duplicating the underlying infrastructure code.

The project includes modules for areas such as:

```text
terraform/
├── bootstrap/
├── environments/
│   ├── dev/
│   ├── prod/
│   └── shared/
└── modules/
    ├── networking/
    ├── compute/
    ├── database/
    ├── monitoring/
    └── frontend/
```

Each module is responsible for a specific infrastructure layer.

---

## Multi-Environment Architecture

The platform supports separate **development** and **production** deployments using the same Terraform modules.

```text
terraform/environments/
├── dev/
├── prod/
└── shared/
```

### Development

Development infrastructure uses its own:

- VPC
- CIDR ranges
- Subnets
- EC2 configuration
- Auto Scaling configuration
- RDS deployment
- Terraform state

Example development network:

```text
VPC: 10.0.0.0/16

Public:
10.0.1.0/24
10.0.2.0/24

Private Application:
10.0.11.0/24
10.0.12.0/24

Private Database:
10.0.21.0/24
10.0.22.0/24
```

### Production

Production is independently deployable and uses separate configuration and Terraform state.

Example production network:

```text
VPC: 10.1.0.0/16

Public:
10.1.1.0/24
10.1.2.0/24

Private Application:
10.1.11.0/24
10.1.12.0/24

Private Database:
10.1.21.0/24
10.1.22.0/24
```

This allows changes to be tested against development before being promoted to production.

---

## Network Architecture

The AWS network is designed around a multi-tier architecture spanning two Availability Zones.

### Public Tier

Public subnets contain internet-facing infrastructure such as the Application Load Balancer and provide connectivity to the Internet Gateway.

### Application Tier

EC2 instances run inside private application subnets.

The instances are not directly exposed to inbound internet traffic. Application traffic reaches them through the Application Load Balancer.

The EC2 instances are managed by an Auto Scaling Group, allowing failed instances to be replaced and compute capacity to scale.

### Database Tier

Amazon RDS runs inside dedicated private database subnets.

The database:

- Is not publicly accessible
- Uses a DB subnet group spanning multiple Availability Zones
- Uses Multi-AZ deployment
- Accepts database traffic only from the application tier through security-group rules

This creates a layered security model:

```text
Internet
   |
   v
Application Load Balancer
   |
   v
Private EC2 / Auto Scaling Group
   |
   v
Private RDS Database
```

---

## Traffic Flow

Application traffic follows this path:

```text
User
  |
  v
Internet
  |
  v
Internet Gateway
  |
  v
Application Load Balancer
  |
  v
Target Group
  |
  v
EC2 Auto Scaling Group
  |
  v
Amazon RDS
```

The Application Load Balancer distributes requests between healthy EC2 instances across multiple Availability Zones.

ALB health checks ensure traffic is sent only to healthy instances.

---

## High Availability

The infrastructure is designed to tolerate individual instance and Availability Zone failures.

High-availability features include:

- Two Availability Zones
- ALB spanning multiple subnets
- EC2 instances distributed through an Auto Scaling Group
- Automatic EC2 health replacement
- RDS Multi-AZ
- Multiple private application subnets
- Multiple database subnets
- NAT connectivity for private application resources

Testing confirmed that requests to the Application Load Balancer are distributed between EC2 instances running in different Availability Zones.

---

## Security Architecture

The platform uses layered network and identity controls.

### Security Groups

Traffic is restricted between infrastructure tiers.

```text
Internet
   |
   | HTTP/HTTPS
   v
ALB Security Group
   |
   | Application traffic
   v
EC2 Security Group
   |
   | Database traffic
   v
RDS Security Group
```

The database is not directly reachable from the internet.

### Private Resources

EC2 application instances and RDS are placed in private subnets.

Only the Application Load Balancer is directly exposed as the application entry point.

### GitHub Authentication

GitHub Actions authenticates to AWS using **OpenID Connect (OIDC)**.

This eliminates the need to store long-lived AWS access keys inside GitHub.

```text
GitHub Actions
      |
      | OIDC token
      v
AWS IAM
      |
      | AssumeRoleWithWebIdentity
      v
TerraformPlatformGitHubActionsRole
      |
      v
AWS Infrastructure
```

The IAM trust policy restricts access to the project's GitHub repository and approved GitHub environments.

---

## Terraform Remote State

Terraform state is stored centrally in Amazon S3 instead of relying solely on local state files.

The remote-state bucket is configured with:

- S3 versioning
- Server-side encryption
- Public access blocking
- Separate state keys for environments
- Terraform state locking

Conceptually:

```text
S3 Terraform State Bucket
│
├── dev/...
└── prod/...
```

This allows development and production infrastructure to be managed independently while protecting Terraform's record of deployed resources.

Versioning also provides recovery options if a state object is accidentally modified or replaced.

---

## CI/CD with GitHub Actions

Terraform deployments are automated through GitHub Actions.

Two primary workflows are used.

### Pull Request Workflow

When infrastructure changes are submitted through a pull request, GitHub Actions automatically runs Terraform checks against both environments.

```text
Feature Branch
      |
      v
Pull Request
      |
      +--> terraform fmt
      |
      +--> terraform validate
      |
      +--> terraform plan
      |
      v
Merge Review
```

This helps catch formatting, syntax, configuration, and infrastructure planning problems before code reaches the main branch.

### Deployment Workflow

After approved changes are merged into `main`, the deployment workflow runs.

```text
Merge to main
      |
      v
Deploy Development
      |
      v
Development Successful
      |
      v
Production Approval
      |
      v
Deploy Production
```

Production uses a GitHub Environment approval gate so production infrastructure is not automatically changed without authorization.

---

## Monitoring and Observability

Amazon CloudWatch provides visibility into infrastructure health.

The platform includes a CloudWatch dashboard and alarms covering metrics such as:

- EC2 CPU utilization
- ALB unhealthy targets
- ALB response time
- RDS CPU utilization
- RDS free storage

This provides centralized monitoring for the compute, load-balancing, and database layers.

---

## Frontend

The repository includes a static frontend that presents information about the infrastructure platform.

```text
frontend/
├── index.html
├── css/
│   └── styles.css
└── js/
    └── main.js
```

The frontend is deployed separately from the dev and prod application infrastructure.

It is hosted using:

```text
User
  |
  | HTTPS
  v
Amazon CloudFront
  |
  v
Amazon S3
  |
  v
Static Frontend
```

CloudFront provides the public HTTPS endpoint while the frontend files are stored in S3.

The frontend is informational and serves as a visual representation of the infrastructure platform rather than acting as an infrastructure-control interface.

---

## Repository Structure

```text
terraform-infrastructure-platform/
│
├── .github/
│   └── workflows/
│       ├── terraform-pr.yml
│       └── terraform-deploy.yml
│
├── docs/
│   └── screenshots/
│
├── frontend/
│   ├── css/
│   ├── js/
│   └── index.html
│
├── scripts/
│
├── terraform/
│   ├── bootstrap/
│   │
│   ├── environments/
│   │   ├── dev/
│   │   ├── prod/
│   │   └── shared/
│   │
│   └── modules/
│       ├── networking/
│       ├── compute/
│       ├── database/
│       ├── monitoring/
│       └── frontend/
│
└── README.md
```

---

## Deployment

### Development

Navigate to the development environment:

```bash
cd terraform/environments/dev
```

Initialize Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review the execution plan:

```bash
terraform plan
```

Deploy:

```bash
terraform apply
```

### Production

```bash
cd terraform/environments/prod

terraform init
terraform validate
terraform plan
terraform apply
```

In the normal project workflow, deployments are performed through GitHub Actions rather than manually.

---

## Destroying Infrastructure

Development:

```bash
cd terraform/environments/dev
terraform destroy
```

Production:

```bash
cd terraform/environments/prod
terraform destroy
```

Always verify the active Terraform environment and execution plan before destroying infrastructure.

---

## Validation

The infrastructure has been validated using both Terraform and AWS tooling.

Terraform validation includes:

```bash
terraform fmt
terraform validate
terraform plan
terraform state list
```

AWS infrastructure validation includes verification of:

- ALB connectivity
- Load balancing between EC2 instances
- Auto Scaling Group health
- Target Group health
- Multi-AZ placement
- RDS availability
- RDS private accessibility
- CloudWatch alarm state
- Terraform state consistency

A clean Terraform plan confirms that deployed infrastructure matches the Terraform configuration:

```text
No changes. Your infrastructure matches the configuration.
```

---

## Key Design Decisions

**Why private EC2 instances?**  
Application servers do not need direct inbound internet exposure. The ALB provides the public entry point.

**Why separate database subnets?**  
The database tier is isolated from both the public internet and application subnet routing.

**Why Multi-AZ?**  
Resources are distributed across Availability Zones to reduce the impact of an AZ failure.

**Why Auto Scaling?**  
The application tier can replace unhealthy instances and adjust capacity without manually managing individual EC2 instances.

**Why modules?**  
Modules allow the same infrastructure architecture to be reused across development and production.

**Why separate Terraform state?**  
Dev and prod can be changed independently without one environment's state affecting the other.

**Why GitHub OIDC?**  
OIDC provides temporary AWS credentials without storing long-lived AWS access keys in GitHub.

**Why production approval?**  
Infrastructure changes can be automatically tested and deployed to development while production remains protected by an explicit approval gate.

**Why CloudFront for the frontend?**  
CloudFront provides a public HTTPS endpoint while allowing the underlying static content to remain stored in S3.

---

## Technologies

- Terraform
- AWS
- Amazon VPC
- Amazon EC2
- EC2 Auto Scaling
- Application Load Balancer
- Amazon RDS
- Amazon S3
- Amazon CloudFront
- Amazon CloudWatch
- AWS IAM
- GitHub Actions
- GitHub OIDC
- HTML
- CSS
- JavaScript

---

## Project Goal

The goal of this project is to demonstrate the design and operation of a reusable Terraform infrastructure platform rather than simply deploying individual AWS resources.

The project demonstrates:

**Infrastructure design → reusable Terraform modules → environment isolation → remote state → automated validation → secure AWS authentication → controlled CI/CD deployment → monitoring → documentation.**