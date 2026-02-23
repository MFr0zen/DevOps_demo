
resource "aws_eks_cluster" "eks_cluster" {
  name     = local.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.private["public_1"].id, aws_subnet.private["public_2"].id]
  }
}



resource "aws_eks_node_group" "nodegroup" {
  node_group_name = local.nodegroup_name
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.private["public_1"].id, aws_subnet.private["public_2"].id]

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 5
  }

  instance_types = ["t3.medium"]
}
