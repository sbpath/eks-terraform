resource "aws_vpc" "EKSTerraform" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Name" = "EKSTerraform",
    "kubernetes.io/cluster/EKSTerraform" = "shared",
  }
}


