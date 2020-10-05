resource "aws_lb_target_group" "tg" {
  name     = "tg-eks-lb-managed"
  port     = 32080
  protocol = "TCP"
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = false
  }
  vpc_id   = aws_vpc.EKSTerraform.id
}
