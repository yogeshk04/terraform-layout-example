resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "ars-cloud-community-${var.infra_env}-vpc"
    Project     = "ARS-cloud-community"
    Environment = var.infra_env
    ManagedBy   = "terrafrom"
  }
}

#output "vpc_id" {
#  value = aws_vpc.test-vpc.id
#}

resource "aws_sub" "public" {
  for_each   = var.public_subnet_numbers
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.cidr_block, 4, each.value)

  tags = {
    Name        = "ars-cloud-community-${var.infa_env}-public-subnet"
    Project     = "ARS-cloud-community"
    Role        = "public"
    Environment = var.infra_env
    ManagedBy   = "terrafrom"
    Subnet      = "${each.key}-${each.value}"
  }
}
resource "aws_sub" "private" {
  for_each   = var.private_subnet_numbers
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.cidr_block, 4, each.value)

  tags = {
    Name        = "ars-cloud-community-${var.infa_env}-private-subnet"
    Project     = "ARS-cloud-community"
    Role        = "private"
    Environment = var.infra_env
    ManagedBy   = "terrafrom"
    Subnet      = "${each.key}-${each.value}"
  }
}
