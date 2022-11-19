#############################################################################################################
# VPC DVWA
#############################################################################################################
resource "aws_vpc" "dvwa-vpc" {
  cidr_block            = var.dvwa-vpc-cidr
  enable_dns_hostnames  = true
  tags = {
    Name     = "vpc-dvwa"
  }
}

# Subnets
resource "aws_subnet" "dvwa-vpc-pub1" {
  vpc_id                  = aws_vpc.dvwa-vpc.id
  cidr_block              = var.dvwa-sn-cidr-pub1
  availability_zone       = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "sn-dvwa-pub-az1"
  }
}

resource "aws_subnet" "dvwa-vpc-pub2" {
  vpc_id                  = aws_vpc.dvwa-vpc.id
  cidr_block              = var.dvwa-sn-cidr-pub2
  availability_zone       = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "sn-dvwa-pub-az1"
  }
}

resource "aws_subnet" "dvwa-vpc-priv1" {
  vpc_id            = aws_vpc.dvwa-vpc.id
  cidr_block        = var.dvwa-sn-cidr-pri1
  availability_zone = var.az1
  tags = {
    Name = "sn-dvwa-pri-az1"
  }
}

resource "aws_subnet" "dvwa-vpc-priv2" {
  vpc_id            = aws_vpc.dvwa-vpc.id
  cidr_block        = var.dvwa-sn-cidr-pri2
  availability_zone = var.az2
  tags = {
    Name = "sn-dvwa-pri-az2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw-dvwa" {
  vpc_id = aws_vpc.dvwa-vpc.id
  tags = {
    Name = "igw-dvwa"
  }
}

# Routes
resource "aws_route_table" "rt-dvwa-pub" {
  vpc_id = aws_vpc.dvwa-vpc.id
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.igw-dvwa.id
  }
  tags = {
    Name     = "rt-dvwa-pub"
  }
}

resource "aws_route_table" "rt-dvwa-pri" {
  vpc_id = aws_vpc.dvwa-vpc.id
  tags = {
    Name     = "rt-dvwa-pri"
  }
}

# Route tables associations

resource "aws_route_table_association" "rt-association-dvwa-pub-sn1" {
  subnet_id      = aws_subnet.dvwa-vpc-pub1.id
  route_table_id = aws_route_table.rt-dvwa-pub.id
}

resource "aws_route_table_association" "rt-association-dvwa-pub-sn2" {
  subnet_id      = aws_subnet.dvwa-vpc-pub2.id
  route_table_id = aws_route_table.rt-dvwa-pub.id
}

resource "aws_route_table_association" "rt-association-dvwa-pri-sn1" {
  subnet_id      = aws_subnet.dvwa-vpc-priv1.id
  route_table_id = aws_route_table.rt-dvwa-pri.id
}

resource "aws_route_table_association" "rt-association-dvwa-pri-sn2" {
  subnet_id      = aws_subnet.dvwa-vpc-priv2.id
  route_table_id = aws_route_table.rt-dvwa-pri.id
}

# Security Group
resource "aws_security_group" "sgr-dvwa-allow-all" {
  name        = "sgr-dvwa-allow-all"
  description = "sgr-dvwa-allow-all"
  vpc_id      = aws_vpc.dvwa-vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sgr-dvwa-allow-all"
  }
}

resource "aws_security_group" "sgr-dvwa-webserver" {
  name        = "sgr-dvwa-webserver"
  description = "sgr-dvwa-webserver"
  vpc_id      = aws_vpc.dvwa-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sgr-dvwa-webserver"
  }
}