resource "aws_vpc" "tfe_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tfe-test"
  }
}

resource "aws_subnet" "tfe_subnet" {
  vpc_id            = "${aws_vpc.tfe_vpc.id}"
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "tfe-test"
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

  network_interface {
    network_interface_id = "${aws_network_interface.web.id}"
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}

output "server_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}
