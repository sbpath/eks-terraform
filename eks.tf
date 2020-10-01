resource "aws_eks_cluster" "tf_eks" {
  name            = "EKS-Terraform-cluster"
  role_arn        = aws_iam_role.tf-eks-master.arn

  vpc_config {
    security_group_ids = [ aws_security_group.tf-eks-master.id ]
    subnet_ids         =  aws_subnet.private.*.id
  }


  depends_on = [
    aws_iam_role_policy_attachment.tf-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.tf-cluster-AmazonEKSServicePolicy,
  ]


}
