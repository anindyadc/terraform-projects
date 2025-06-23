# outputs.tf
output "alb_dns_name" {
  value = module.alb.dns_name
}

output "app_instance_1_ip" {
  value = module.app_instance_1.public_ip
}

output "app_instance_2_ip" {
  value = module.app_instance_2.public_ip
}

output "db_instance_private_ip" {
  value = module.db_instance.private_ip
}

