resource "aws_subnet" "private" {
  for_each = local.private_subnests

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.availability_zone

  tags = {
    Name                              = "${local.environment}-${each.value.prsubnet_name}"
    environment                       = local.environment
    Terraforn                         = "true"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/dev-demo"  = "owned"
  }
}