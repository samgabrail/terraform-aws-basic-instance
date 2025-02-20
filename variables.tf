variable "prefix" {
  default = "tfc"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  description = "type of EC2 instance to provision."
  default = "t2.nano"
}

variable "name" {
  description = "name to pass to name tag"
  default = "Sam Gabrail"
}

variable "owner" {
  description = "name to pass to owner tag"
  default = "samgabrail"
}

variable "ttl" {
  description = "ttl to pass to ttl tag"
  default = "4"
}

variable "se-region" {
  description = "SE region assigned"
  default = "public-sector"
}

variable "purpose" {
  description = "Purpose; Required if TTL = -1"
  default = "demo"
}

variable "terraform" {
  description = "Built by Terraform"
  default = true
}

variable "customer" {
  description = "Billable Customer"
  default = "test"
}

variable "tfc-workspace" {
  description = "TFC Workspace"
  default = "terraform-aws-basic-instance"
}

variable "lifecycle-action" {
  description = "stop or terminate (default)"
  default = "terminate"
}
