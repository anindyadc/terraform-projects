output "alb_dns" {
  description = "The DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}
