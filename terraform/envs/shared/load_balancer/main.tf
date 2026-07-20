data "aws_instance" "target" {
  filter {
    name   = "tag:Project"
    values = [var.project_name]
  }

  filter {
    name   = "tag:Environment"
    values = [var.target_environment]
  }

  filter {
    name   = "tag:Component"
    values = [var.target_component]
  }
}

data "aws_subnet" "target" {
  id = data.aws_instance.target.subnet_id
}

resource "aws_lb" "application" {
  name               = "${local.name_prefix}-nlb"
  load_balancer_type = "network"
  internal           = false
  subnets            = [data.aws_instance.target.subnet_id]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-nlb"
  })
}

resource "aws_lb_target_group" "application" {
  name        = "${local.name_prefix}-tg"
  port        = var.app_nodeport
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = data.aws_subnet.target.vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/healthz"
    port                = tostring(var.app_nodeport)
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 10
    matcher             = "200-399"
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-tg"
  })
}

resource "aws_lb_target_group_attachment" "application" {
  target_group_arn = aws_lb_target_group.application.arn
  target_id        = data.aws_instance.target.id
  port             = var.app_nodeport
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.application.arn
  port              = 443
  protocol          = "TLS"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application.arn
  }
}
