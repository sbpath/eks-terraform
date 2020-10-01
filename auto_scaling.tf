resource "aws_autoscaling_attachment" "asg" {
  autoscaling_group_name = lookup(lookup(lookup(aws_eks_node_group.node1, "resources")[0], "autoscaling_groups")[0], "name")
  alb_target_group_arn   = aws_lb_target_group.tg.arn
}
