
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${local.environment}-${local.igw_name}"
    environment = local.environment
    Terraforn   = "true"
  }
}