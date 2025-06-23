variable "cluster_name" {}
variable "family" {}
variable "cpu" {}
variable "memory" {}
variable "execution_role_arn" {}
variable "container_definitions" {}
variable "service_name" {}
variable "desired_count" {}
variable "subnets" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}
variable "target_group_arn" {}
variable "container_name" {}
variable "container_port" {}

