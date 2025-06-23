variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "security_group_ids" {
  type = list(string)
}
variable "key_name" {}
variable "name" {
  default = "ec2-instance"
}
variable "associate_public_ip" {
  type    = bool
  default = false
}
variable "user_data" {
  type    = string
  default = null
}
