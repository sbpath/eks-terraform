resource "aws_subnet" "public" {
  count = length(var.subnet_cidrs_public)
  vpc_id = aws_vpc.EKSTerraform.id
  cidr_block = var.subnet_cidrs_public[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "EKSTerraform-public"
    "kubernetes.io/cluster/EKS-Terraform-cluster" =  "shared"
  }
}

resource "aws_subnet" "private" {
  count = length(var.subnet_cidrs_private)
  vpc_id = aws_vpc.EKSTerraform.id
  cidr_block = var.subnet_cidrs_private[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "EKSTerraform-private"
    "kubernetes.io/cluster/EKS-Terraform-cluster" =  "shared"
  }
}
