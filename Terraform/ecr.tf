resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${local.environment}-${local.ecr_name}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${local.environment}-${local.ecr_name}"
    environment = local.environment
    Terraforn   = "true"
  }
}