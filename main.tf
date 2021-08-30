terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.50.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    owner            = var.owner
    se-region        = var.se-region
    purpose          = var.purpose
    ttl              = var.ttl #-1 must has justification as purpose
    terraform        = var.terraform
    creator          = var.name
    customer         = var.customer
    tfc-workspace    = var.tfc-workspace
    lifecycle-action = var.lifecycle-action
    Name             = "${var.prefix}-${var.owner}-${var.purpose}-${var.customer}"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_vpc" "tfc_vpc" {
  cidr_block = "172.16.0.0/16"
  tags       = local.common_tags
}

resource "aws_subnet" "tfc_subnet" {
  vpc_id            = aws_vpc.tfc_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = var.availability_zone
  tags              = local.common_tags
}

resource "aws_network_interface" "web" {
  subnet_id   = aws_subnet.tfc_subnet.id
  private_ips = ["172.16.10.100"]
  tags        = local.common_tags
}

resource "aws_security_group" "tfc_sg" {
  name = "${var.prefix}-security-group"

  vpc_id = aws_vpc.tfc_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = local.common_tags
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tfc_sg.id]
  tags                        = local.common_tags
}

output "server_ip" {
  value       = ["${aws_instance.web.*.public_ip}"]
  description = "The public IP address of the web server instance."
}
