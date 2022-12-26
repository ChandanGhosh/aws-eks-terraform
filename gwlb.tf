resource "aws_security_group_rule" "gwlb_geneve_6081_rule" {
  description       = "GENEVE port for GWLB"
  security_group_id = data.aws_security_group.eks_cluster_security_group.id
  type              = "ingress"
  from_port         = 6081
  to_port           = 6081
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]

  depends_on = [
    aws_eks_node_group.this,
    aws_launch_template.this
  ]
}

resource "aws_security_group_rule" "gwlb_healthcheck_8080_rule" {
  description = "Health Check port for GWLB"

  security_group_id = data.aws_security_group.eks_cluster_security_group.id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

  depends_on = [
    aws_eks_node_group.this,
    aws_launch_template.this
  ]
}

resource "aws_lb_target_group" "gwlb_geneve_tg" {
  name        = "${local.cluster_name}-cluster-target-group"
  target_type = "instance"
  protocol    = "GENEVE"
  port        = 6081
  vpc_id      = aws_vpc.this.id

  health_check {
    enabled  = true
    protocol = "TCP"
    interval = 30
    port     = "8080"
  }

  depends_on = [
    aws_eks_node_group.this,
    aws_launch_template.this
  ]
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.gwlb_geneve_tg.arn
  target_id        = data.aws_instance.node.id
  port             = 6081

  depends_on = [
    aws_eks_node_group.this,
    aws_launch_template.this
  ]
}

resource "aws_lb" "gwlb" {
  name                       = "${local.cluster_name}-cluster-gwlb"
  load_balancer_type         = "gateway"
  internal                   = false
  enable_deletion_protection = false

  subnets = flatten([aws_subnet.private[*].id])

  tags = merge(
    var.tags
  )

  depends_on = [
    aws_eks_node_group.this,
    aws_launch_template.this
  ]
}

resource "aws_lb_listener" "gwlb-listener" {
  load_balancer_arn = aws_lb.gwlb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gwlb_geneve_tg.arn
  }

  depends_on = [
    aws_eks_node_group.this,
    aws_launch_template.this
  ]
}

resource "aws_vpc_endpoint_service" "gwlb_endpoint_service" {
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.gwlb.arn]

  tags = merge(
    {
      Name = "${var.project}-endpoint-svc"
    },
    var.tags,
  )

  depends_on = [
    aws_lb.gwlb
  ]
}