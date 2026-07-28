########################################
# Generic security group
#
# Creates one security group and populates it from two lists:
#   - ingress_rules: inbound rules (CIDR-based)
#   - egress_rules:  outbound rules (CIDR-based); if empty, defaults to
#                    allow-all-egress (the most common baseline).
########################################

locals {
  name = "${var.project_name}-${var.environment}-${var.name}"

  # Default egress: allow all outbound if the caller didn't specify.
  effective_egress_rules = length(var.egress_rules) > 0 ? var.egress_rules : [
    {
      description = "Allow all outbound"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
    }
  ]
}

resource "aws_security_group" "this" {
  name        = local.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = local.name
  })

  # Rules are managed via aws_vpc_security_group_*_rule below so callers
  # can add/remove them without recreating the group.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = {
    for idx, rule in var.ingress_rules :
    "${rule.from_port}-${rule.to_port}-${rule.protocol}-${idx}" => rule
  }

  security_group_id = aws_security_group.this.id
  description       = try(each.value.description, null)
  cidr_ipv4         = each.value.cidr_blocks[0]
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = {
    for idx, rule in local.effective_egress_rules :
    "${rule.from_port}-${rule.to_port}-${rule.protocol}-${idx}" => rule
  }

  security_group_id = aws_security_group.this.id
  description       = try(each.value.description, null)
  cidr_ipv4         = each.value.cidr_blocks[0]
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
}
