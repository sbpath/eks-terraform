resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.ekstest.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
