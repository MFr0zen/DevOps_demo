output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

# output "ecr_url" {
#   value = aws_ecr_repository.ecr_repo.repository_url
# }