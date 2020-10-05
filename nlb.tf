resource "aws_lb" "ekstest" {
  name               = "ekstest-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = aws_subnet.public.*.id
#  security_groups = [ aws_security_group.tf-eks-lb.id ]
#  enable_deletion_protection = true
  tags = {
    Environment = "Eks-test"
  }
}
