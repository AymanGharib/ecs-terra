output "tg_arn" {
  value = aws_lb_target_group.frontend_tg.arn
}

output "alb_dns_name" {
  value = aws_lb.frontend_alb.dns_name
  description = "The DNS name of the frontend ALB"
}