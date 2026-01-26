

resource "aws_ecr_repository" "devopsdemo_ecr_repo" {
  name                 = "${var.aws_environement}_${var.aws_ecr_name}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name         = "${var.aws_environement}_${var.aws_ecr_name}"
    Environement = var.aws_environement
    Terraforn    = "true"
  }
}


resource "aws_vpc" "devopsDemo_vpc" {
  cidr_block = var.aws_vpc_cidr

  tags = {
    Name         = "${var.aws_environement}_${var.aws_vpc_name}"
    Environement = var.aws_environement
    Terraforn    = "true"
  }


}








