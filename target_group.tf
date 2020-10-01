resource "aws_lb_target_group" "tg" {
  name     = "tg-eks-lb-managed"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.EKSTerraform.id
}
