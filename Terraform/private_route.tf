resource "aws_route_table" "privaterout" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name        = "${local.environment}-${local.prrout_name}"
    environment = local.environment
    Terraforn   = "true"
  }
}


resource "aws_route_table_association" "private" {
  for_each = local.private_subnests

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.privaterout.id
}