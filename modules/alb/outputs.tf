output "dns_name" {
  description = "ALB Dns"
  value       = aws_lb.this.dns_name
}
output "target_group_arn" {
  description = "ALB Dns"
  value       = aws_lb_target_group.alb_tg.arn
}