########################################
# Application Load Balancer + target group + listener
########################################

locals {
  name = "${var.project_name}-${var.environment}-${var.name}"
}

resource "aws_lb" "this" {
  name               = local.name
  internal           = var.internal
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, {
    Name = local.name
  })
}

resource "aws_lb_target_group" "this" {
  name        = "${local.name}-tg"
  port        = var.target_port
  protocol    = var.target_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    path                = var.health_check_path
    protocol            = var.target_protocol
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }

  tags = merge(var.tags, {
    Name = "${local.name}-tg"
  })
}

resource "aws_lb_target_group_attachment" "this" {
  for_each         = toset(var.target_ids)
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = each.value
  port             = var.target_port
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = var.listener_protocol == "HTTPS" ? var.ssl_policy : null
  certificate_arn   = var.listener_protocol == "HTTPS" ? var.certificate_arn : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
