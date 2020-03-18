variable "prefix" {
  default = "tfe"
}

variable "availability_zone" {
  default = "us-west-2a"
}

variable "aws_region" {
  default = "us-west-2"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
}

resource "aws_vpc" "tfe_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "${var.prefix}-test"
  }
}

resource "aws_subnet" "tfe_subnet" {
  vpc_id            = "${aws_vpc.tfe_vpc.id}"
  cidr_block        = "172.16.10.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.prefix}-test"
  }
}

resource "aws_network_interface" "web" {
  subnet_id   = "${aws_subnet.tfe_subnet.id}"
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-22b9a343" # us-west-2
  instance_type = "t2.micro"


  associate_public_ip_address = true
}

output "server_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
  description = "The public IP address of the web server instance."
}
