resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "yoars-practice-${var.infra_env}-vpc"
    Project     = "Cloud Practice"
    Environment = var.infra_env
    ManagedBy   = "terrafrom"
  }
}

#output "vpc_id" {
#  value = aws_vpc.test-vpc.id
#}

resource "aws_subnet" "public" {
  for_each = var.public_subnet_numbers
  vpc_id   = aws_vpc.vpc.id
  #cidr_block = cidrsubnet(aws_vpc.cidr_block, 4, each.value)
  cidr_block = "15.0.0.0/28"

  tags = {
    Name        = "yoars-practice-${var.infra_env}-public-subnet"
    Project     = "Cloud Practice"
    Role        = "public"
    Environment = var.infra_env
    ManagedBy   = "terrafrom"
    Subnet      = "${each.key}-${each.value}"
  }
}
resource "aws_subnet" "private" {
  for_each = var.private_subnet_numbers
  vpc_id   = aws_vpc.vpc.id
  #cidr_block = cidrsubnet(aws_vpc.cidr_block, 4, each.value)
  cidr_block = "15.0.0.32/28"

  tags = {
    Name        = "yoars-practice-${var.infra_env}-private-subnet"
    Project     = "Cloud Practice"
    Role        = "private"
    Environment = var.infra_env
    ManagedBy   = "terrafrom"
    Subnet      = "${each.key}-${each.value}"
  }
}
