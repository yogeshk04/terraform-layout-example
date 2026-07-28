########################################
# Single EC2 instance (with optional Elastic IP)
########################################

locals {
  name = "${var.project_name}-${var.environment}-${var.name}"
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  user_data                   = var.user_data
  associate_public_ip_address = var.associate_public_ip_address

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = true
  }

  metadata_options {
    http_tokens   = "required" # Enforce IMDSv2.
    http_endpoint = "enabled"
  }

  tags = merge(var.tags, {
    Name = local.name
  })
}

resource "aws_eip" "this" {
  count  = var.allocate_eip ? 1 : 0
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${local.name}-eip"
  })
}

resource "aws_eip_association" "this" {
  count         = var.allocate_eip ? 1 : 0
  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.this[0].id
}
