resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "${local.environment}-${local.nat_name}"
    environment = local.environment
    Terraforn   = "true"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id


  tags = {
    Name        = "${local.environment}-${local.nat_name}"
    environment = local.environment
    Terraforn   = "true"
  }

  depends_on = [aws_internet_gateway.igw]
}