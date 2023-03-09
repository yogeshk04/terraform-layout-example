# Internet Gateway (IGW)

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "ars-cloud-community-${var.infa_env}-vpc"
    Project     = "ARS-cloud-community"
    Environment = var.infra_env
    VPC         = aws_vpc.vpc.id
    ManagedBy   = "terraform"
  }
}

# NAT Gateway (NGW)

resource "aws_eip" "nat" {
  vpc = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "ars-cloud-community-${var.infa_env}-eip"
    Project     = "ARS-cloud-community"
    Environment = var.infra_env
    VPC         = aws_vpc.vpc.id
    ManagedBy   = "terraform"
    Role        = "private"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[element(keys(aws_subnet.public), 0)].id

  tags = {
    Name        = "ars-cloud-community-${var.infa_env}-ngw"
    Project     = "ARS-cloud-community"
    Environment = var.infra_env
    VPC         = aws_vpc.vpc.id
    ManagedBy   = "terraform"
    Role        = "private"
  }
}

# Route Tables and Routes

# Pubic Route table subnet with IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "ars-cloud-community-${var.infa_env}-public-rt"
    Project     = "ARS-cloud-community"
    Role        = "public"
    Environment = var.infra_env
    VPC         = aws_vpc.vpc.id
    ManagedBy   = "terraform"
  }
}

# Private Route Table subnet with NGW
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "ars-cloud-community-${var.infa_env}-private-rt"
    Project     = "ARS-cloud-community"
    Role        = "private"
    Environment = var.infra_env
    VPC         = aws_vpc.vpc.id
    ManagedBy   = "terraform"
  }

}

# Public Route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Private Route
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ngw.id
}

# Public Route to public Route Table for Public subnets
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route.public.id
}

# Private Route to Private Route Table for Private Subnets
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  susubnet_id    = aws_subnet.private[each.key].id
  route_table_id = aws_route.private.id
}
