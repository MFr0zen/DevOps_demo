resource "aws_instance" "app" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = local.instance_type
  subnet_id            = aws_subnet.private["public_1"].id
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]


  user_data = templatefile("${path.module}/user_data.sh", {
    region          = local.region
    ecr_repo_url    = aws_ecr_repository.ecr_repo.repository_url #should use -> aws_ecr_repository.ecr_repo.ecr_repo_url  but first add ecr creation
    app_port        = local.app_port
    image_tags_name = local.image_tags_name
  })

  tags = {
    name      = "${local.environment}-${local.instance_name}"
    Terraforn = true
  }
}