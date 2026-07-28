########################################
# Auto Scaling Group backed by a Launch Template
#
# aws_launch_configuration is deprecated, so this module uses
# aws_launch_template as the industry-standard replacement.
########################################

locals {
  name = "${var.project_name}-${var.environment}-${var.name}"
}

resource "aws_launch_template" "this" {
  name_prefix   = "${local.name}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.security_group_ids

  user_data = var.user_data == null ? null : base64encode(var.user_data)

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.root_volume_size
      volume_type = var.root_volume_type
      encrypted   = true
    }
  }

  metadata_options {
    http_tokens   = "required" # Enforce IMDSv2.
    http_endpoint = "enabled"
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name = local.name
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix         = "${local.name}-"
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = var.target_group_arns
  health_check_type   = length(var.target_group_arns) > 0 ? "ELB" : "EC2"

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = merge(var.tags, { Name = local.name })

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
