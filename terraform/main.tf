provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-servian"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "vpc-servian-igw"
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_blocks)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnet_blocks, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name   = "public-${element(var.availability_zones, count.index)}"
    Public = true
  }
}

# Create Private Subnet For RDS 
resource "aws_subnet" "private_rds" {
  count                   = length(var.rds_subnet_blocks)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.rds_subnet_blocks, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name   = "private-rds-${element(var.availability_zones, count.index)}"
    Public = false
  }
}

# Create Private Subnet For EC2 
resource "aws_subnet" "private_ec2" {
  count                   = length(var.ec2_subnet_blocks)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.ec2_subnet_blocks, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name   = "private-app-${element(var.availability_zones, count.index)}"
    Public = false
  }
}

resource "aws_security_group" "public_default" {
  name        = "security_group_public_default"
  description = "Terraform SG"
  vpc_id      = aws_vpc.vpc.id

  # Allow outbound internet access.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-default-sg"
  }
}
