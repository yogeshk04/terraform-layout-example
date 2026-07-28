########################################
# RDS instance (MySQL/PostgreSQL) + subnet group + security group
########################################

locals {
  name = "${var.project_name}-${var.environment}-${var.name}"
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.name}-subnets"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${local.name}-subnets"
  })
}

resource "aws_security_group" "this" {
  name        = "${local.name}-sg"
  description = "Security group for ${local.name} RDS instance"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${local.name}-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "db" {
  for_each = toset(var.allowed_cidr_blocks)

  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value
  from_port         = var.port
  to_port           = var.port
  ip_protocol       = "tcp"
  description       = "Allow DB traffic from ${each.value}"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound"
}

resource "aws_db_instance" "this" {
  identifier              = local.name
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  storage_encrypted       = true
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  port                    = var.port
  multi_az                = var.multi_az
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.this.id]
  publicly_accessible     = false
  skip_final_snapshot     = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${local.name}-final-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  deletion_protection     = var.deletion_protection
  apply_immediately       = var.apply_immediately

  tags = merge(var.tags, {
    Name = local.name
  })

  # `timestamp()` in final_snapshot_identifier would otherwise cause endless diffs.
  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }
}
