resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${local.environment}-${local.sg_name}"
    Terraforn = true
  }
}



resource "aws_security_group" "ec2_sg" {
  name   = local.ec2_sg_name
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "${local.environment}-${local.ec2_sg_name}"
  }
}