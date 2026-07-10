# EC2 Nginx Deployment using Terraform

## Overview

This project demonstrates Infrastructure as Code (IaC) using Terraform to provision an Ubuntu 20.04 EC2 instance in the default AWS VPC. During provisioning, Nginx is installed automatically using a user_data script, and the default web page is replaced with a custom HTML page.

---

## Architecture

```
Internet
    │
    ▼
Security Group
├── SSH (22) → My Public IP
└── HTTP (80) → 0.0.0.0/0
    │
    ▼
Ubuntu 20.04 EC2 (t2.micro)
    │
user_data
    │
Install Nginx
    │
Custom HTML Page
```

---

## Resources Created

- AWS EC2 Instance (Ubuntu 20.04 LTS)
- Security Group
- Nginx Web Server

---

## Security

- SSH (22) is restricted to the deployer's current public IP, which is detected automatically during deployment.
- HTTP (80) is open to the Internet to allow browser access.

---

## Enhancements

Compared to the basic assignment requirements, the following best practices were implemented:

- Automatically discovers the latest Ubuntu 20.04 LTS AMI.
- Automatically detects the deployer's current public IP for SSH access.
- Restricts SSH access to a single IP address instead of `0.0.0.0/0`.
- Uses Terraform outputs for easy access to deployment details.

---

## Terraform Commands

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

---

## Outputs

Terraform displays:

- EC2 Public IP
- Website URL
- Ubuntu AMI ID
- Detected Public IP

---

## Screenshots

### 1. Terraform Initialization

![Terraform Init](screenshots/01-terraform-init.png)

---

### 2. Terraform Validation

![Terraform Validate](screenshots/02-terraform-validate.png)

---

### 3. Terraform Outputs

![Terraform Output](screenshots/03-terraform-output.png)

---

### 4. Nginx Home Page

![Nginx](screenshots/04-nginx-homepage.png)

---

### 5. EC2 Instance Running

![EC2 Instance](screenshots/05-ec2-instance.png)

---

### 6. Security Group Rules

![Security Group](screenshots/06-security-group.png)

---

### 7. Default VPC

![Default VPC](screenshots/07-default-vpc.png)

---

### 8. Terraform Destroy

![Terraform Destroy](screenshots/08-terraform-destroy.png)

---

### 9. EC2 Successfully Removed

![EC2 Terminated](screenshots/09-ec2-terminated.png)

---

## Cleanup

All resources can be removed using:

```bash
terraform destroy
```

This removes:

- EC2 Instance
- Security Group

No infrastructure remains after cleanup.
