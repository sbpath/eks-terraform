#resource "aws_eks_node_group" "node" {
#  cluster_name = aws_eks_cluster.tf_eks.name
#  node_group_name = "aws-managed-node-group"
#  subnet_ids         =  aws_subnet.private.*.id
#  node_role_arn = aws_iam_role.tf-eks-node.arn
#  scaling_config {
#    desired_size = 1
#    max_size     = 1
#    min_size     = 1
#  }
#  depends_on = [ aws_eks_cluster.tf_eks ]
#}

