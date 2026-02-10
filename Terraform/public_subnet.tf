resource "aws_subnet" "public" {
  count = length(local.availability_zones)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_subnets[count.index]
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${local.environment}-${local.pubsubnet_name}-${count.index}"
    environment = local.environment
    Terraforn   = "true"
  }
}