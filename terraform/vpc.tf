# VPC principal para a infraestrutura.
# Esta VPC provê a base de rede com DNS habilitado para EKS e componentes AWS.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

# Internet Gateway para tráfego de saída/entrada da VPC.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnets : idx => cidr }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.availability_zones[each.key]
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.environment}-public-${each.key}"
    Environment = var.environment
    Tier        = "public"
  }
}

resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnets : idx => cidr }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]
  tags = {
    Name        = "${var.environment}-private-${each.key}"
    Environment = var.environment
    Tier        = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  for_each   = aws_subnet.public
  subnet_id  = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count = var.create_nat_gateway ? 1 : 0
  vpc   = true
  tags = {
    Name        = "${var.environment}-nat-eip"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "nat" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name        = "${var.environment}-nat"
    Environment = var.environment
  }
}

resource "aws_route_table" "private" {
  count  = var.create_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }
  tags = {
    Name        = "${var.environment}-private-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private" {
  count          = var.create_nat_gateway ? length(var.private_subnets) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}
