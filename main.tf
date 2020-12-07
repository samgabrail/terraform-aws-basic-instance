terraform {
  required_version = ">= 0.11.0"
}

provider aws {
  region = var.aws_region
}

locals {
  common_tags = {
    owner = var.owner
    se-region = var.se-region
    purpose = var.purpose
    ttl = var.ttl #-1 must has justification as purpose
    terraform = var.terraform
    creator = var.name
    customer = var.customer
    tfe-workspace = var.tfe-workspace
    lifecycle-action = var.lifecycle-action
    Name = "${var.owner}-{var.purpose}-{var.customer}" 
  }
}

resource "aws_vpc" "tfe_vpc" {
  cidr_block = "172.16.0.0/16"
  tags = local.common_tags
}

resource "aws_subnet" "tfe_subnet" {
  vpc_id            = aws_vpc.tfe_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = var.availability_zone
  tags = local.common_tags
}

resource "aws_network_interface" "web" {
  subnet_id   = aws_subnet.tfe_subnet.id
  private_ips = ["172.16.10.100"]
  tags = local.common_tags
}

resource "aws_instance" "web" {
  ami           = "ami-22b9a343" # us-west-2
  instance_type = "t2.nano"
  associate_public_ip_address = true
  tags = local.common_tags
}

output "server_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
  description = "The public IP address of the web server instance."
}
