# 10.0.0.0/16
# AZ-A
# Public:      10.0.1.0/24
# Private App: 10.0.11.0/24
# Private DB:  10.0.21.0/24

# AZ-B
# Public:      10.0.2.0/24
# Private App: 10.0.12.0/24
# Private DB:  10.0.22.0/24


resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "terraform-platform-${var.environment}-vpc"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ---------------------------------------------------------
# Availability Zones
# ---------------------------------------------------------

data "aws_availability_zones" "available" {
  state = "available"
}

# ---------------------------------------------------------
# Public Subnets
# ---------------------------------------------------------

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "terraform-platform-${var.environment}-public-a"
    Environment = var.environment
    Type        = "public"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name        = "terraform-platform-${var.environment}-public-b"
    Environment = var.environment
    Type        = "public"
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# Private Application Subnets
# ---------------------------------------------------------

resource "aws_subnet" "private_app_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "terraform-platform-${var.environment}-private-app-a"
    Environment = var.environment
    Type        = "private-app"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "private_app_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name        = "terraform-platform-${var.environment}-private-app-b"
    Environment = var.environment
    Type        = "private-app"
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# Private Database Subnets
# ---------------------------------------------------------

resource "aws_subnet" "private_db_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "terraform-platform-${var.environment}-private-db-a"
    Environment = var.environment
    Type        = "private-db"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "private_db_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name        = "terraform-platform-${var.environment}-private-db-b"
    Environment = var.environment
    Type        = "private-db"
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# Internet Gateway
# ---------------------------------------------------------

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "terraform-platform-${var.environment}-igw"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# Elastic IPs for NAT Gateways
# ---------------------------------------------------------

resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name        = "terraform-platform-${var.environment}-nat-eip-a"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_eip" "nat_b" {
  domain = "vpc"

  tags = {
    Name        = "terraform-platform-${var.environment}-nat-eip-b"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# NAT Gateways
# ---------------------------------------------------------

resource "aws_nat_gateway" "a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name        = "terraform-platform-${var.environment}-nat-a"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_nat_gateway" "b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_b.id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name        = "terraform-platform-${var.environment}-nat-b"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# Public Route Table
# ---------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "terraform-platform-${var.environment}-public-rt"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}


# ---------------------------------------------------------
# Private Application Route Tables
# ---------------------------------------------------------

resource "aws_route_table" "private_app_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "terraform-platform-${var.environment}-private-app-a-rt"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table" "private_app_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "terraform-platform-${var.environment}-private-app-b-rt"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_route" "private_app_a_nat" {
  route_table_id         = aws_route_table.private_app_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.a.id
}

resource "aws_route" "private_app_b_nat" {
  route_table_id         = aws_route_table.private_app_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.b.id
}


# ---------------------------------------------------------
# Private Database Route Table
# ---------------------------------------------------------

resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "terraform-platform-${var.environment}-private-db-rt"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# Route Table Associations
# ---------------------------------------------------------

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_app_a" {
  subnet_id      = aws_subnet.private_app_a.id
  route_table_id = aws_route_table.private_app_a.id
}

resource "aws_route_table_association" "private_app_b" {
  subnet_id      = aws_subnet.private_app_b.id
  route_table_id = aws_route_table.private_app_b.id
}

resource "aws_route_table_association" "private_db_a" {
  subnet_id      = aws_subnet.private_db_a.id
  route_table_id = aws_route_table.private_db.id
}

resource "aws_route_table_association" "private_db_b" {
  subnet_id      = aws_subnet.private_db_b.id
  route_table_id = aws_route_table.private_db.id
}