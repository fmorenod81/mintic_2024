locals {
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
}

# VPC
resource "aws_vpc" "vpc" {
  provider = aws.l3group
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    #Name        = "${var.environment}-vpc"
    Name        = "VPC-Ejercicio5-${var.environment}"
    Environment = var.environment
  }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  provider = aws.l3group
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    #Name        = "${var.environment}-${element(local.availability_zones, count.index)}-public-subnet"
    Name        = "Subnet_VPC_ejercicio5-${element(local.availability_zones, count.index)}-public-subnet"

    Environment = "${var.environment}"
  }
}

#Internet gateway
resource "aws_internet_gateway" "ig" {
  provider = aws.l3group
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"        = "${var.environment}-igw"
    "Environment" = var.environment
  }
}

# Elastic-IP (eip) for EC2
resource "aws_eip" "ec2_eip" {
  provider = aws.l3group
  depends_on = [aws_internet_gateway.ig]
}


# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  provider = aws.l3group
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  provider = aws.l3group
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}


# Route table associations for Public  Subnets
resource "aws_route_table_association" "public" {
  provider = aws.l3group
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Security Groups for Public Subnets
resource "aws_security_group" "public" {
  provider = aws.l3group
  count       = length(var.public_subnets_cidr)
  description = "Allow specific inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-public-sec_group-${element(aws_subnet.public_subnet.*.id, count.index)}"
    Environment = "${var.environment}"
  }
  ## This is a hack, create for public subnets some ports in some subnets
   dynamic "ingress" {
        for_each = var.public_subnets_ports
        content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = [ "0.0.0.0/0" ]
        }
    }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  provider = aws.l3group
  count          = length(aws_security_group.public)
  security_group_id = element(aws_security_group.public.*.id, count.index)
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

