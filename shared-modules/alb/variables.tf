variable "name" {}
variable "subnets" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}
variable "vpc_id" {}
variable "port" {
  default = 80
}

variable "target_ids" {
  description = "List of instance IDs to register in the ALB"
  type        = list(string)
}
