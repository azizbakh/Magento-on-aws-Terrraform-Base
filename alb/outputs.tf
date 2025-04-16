output "alb_dns_name" {
  description = "Nom DNS du Load Balancer"
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "ARN du Target Group"
  value       = aws_lb_target_group.this.arn
}
