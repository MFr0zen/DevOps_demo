resource "aws_lb" "app_alb" {
  name               = local.load_balancer_name
  load_balancer_type = local.load_balancer_type
  internal           = false

  security_groups = [aws_security_group.sg.id]
  subnets         = [aws_subnet.public[0].id, aws_subnet.public[1].id]

  tags = {
    name      = "${local.environment}-${local.load_balancer_name}"
    Terraforn = true
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.id
  }
  tags = {
    Terraforn = true
  }
}