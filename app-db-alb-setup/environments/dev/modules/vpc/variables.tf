# modules/vpc/variables.tf
variable "vpc_cidr" {}
variable "public_subnet_cidrs" {
  type = list(string)
}
variable "private_subnet_cidrs" {
  type    = list(string)
  default = []
}
variable "enable_nat_gateway" {
  type    = bool
  default = false
}

