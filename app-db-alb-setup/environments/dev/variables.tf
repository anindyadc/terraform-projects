variable "region" {
  default = "us-east-1"
}

variable "ami_id" {}
variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = []
}