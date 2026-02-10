resource "aws_lb_target_group" "app_tg" {
  vpc_id   = aws_vpc.main.id
  name     = local.target_group_name
  port     = 8000
  protocol = "HTTP"

  health_check {
    interval            = 30
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    name      = "${local.environment}-${local.target_group_name}"
    Terraforn = true
  }
}

resource "aws_lb_target_group_attachment" "ec2_attach" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app.id
  port             = 8000
}