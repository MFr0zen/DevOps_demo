resource "aws_route_table" "publicrout" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${local.environment}-${local.pubrout_name}"
    environment = local.environment
    Terraforn   = "true"
  }
}

resource "aws_route_table_association" "public" {
  count = length(local.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.publicrout.id
}