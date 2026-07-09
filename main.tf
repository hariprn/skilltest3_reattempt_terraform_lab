terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

provider "aws" {
  region = var.region
}

#################################################
# Default VPC
#################################################

data "aws_vpc" "default" {
  default = true
}

#################################################
# Detect Current Public IP
#################################################

data "http" "myip" {
  url = "https://checkip.amazonaws.com"
}

#################################################
# Latest Ubuntu 20.04 LTS AMI
#################################################

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#################################################
# Security Group
#################################################

resource "aws_security_group" "nginx_sg" {

  name        = "terraform-nginx-sg"
  description = "Security Group for Nginx Server"
  vpc_id      = data.aws_vpc.default.id

  #################################################
  # SSH - Only from my current public IP
  #################################################

  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    cidr_blocks = [
      "${chomp(data.http.myip.response_body)}/32"
    ]
  }

  #################################################
  # HTTP - Public
  #################################################

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  #################################################
  # Outbound
  #################################################

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "terraform-nginx-sg"
  }
}

#################################################
# EC2 Instance
#################################################

resource "aws_instance" "nginx" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.nginx_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash

              apt-get update -y
              apt-get install -y nginx

              cat <<HTML > /var/www/html/index.html
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Terraform Assignment</title>
              </head>

              <body style="font-family:Arial;text-align:center;margin-top:100px;">
                  <h1>Welcome to the Terraform-managed Nginx Server on Ubuntu</h1>
              </body>

              </html>
              HTML

              systemctl enable nginx
              systemctl restart nginx
              EOF

  tags = {
    Name = "terraform-nginx-server"
  }
}
