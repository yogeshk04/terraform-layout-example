resource "aws_instance" "ars-ec2" {
  ami           = var.instance_ami
  instance_type = var.instance_size

  root_block_device {
    volume_size = var.instance_root_device_size
    volume_type = "gp3"
  }

  tags = {
    Name        = "ars-ec2-${var.infra_env}-web"
    Role        = var.infra_role
    Project     = "ARS-cloud-community"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}

resource "aws_eip" "ars-eip" {
  vpc = true

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "ars-eip-${var.infra_env}-web-address"
    Role        = var.infra_role
    Project     = "ARS-cloud-community"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}

resource "aws_eip_association" "eip-association" {
  instance_id   = aws_instance.ars-ec2.id
  allocation_id = aws_eip.ars-eip.id
}
