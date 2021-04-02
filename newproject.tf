provider "aws" {
  region  = "us-east-1"
}

variable "project" {
  default = "NewProject"
}

variable "subnet_cidrs_public" {
  default = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  type = list
}

variable "subnet_cidrs_private" {
  default = ["10.0.70.0/24", "10.0.80.0/24", "10.0.90.0/24"]
  type = list
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
  type = list
}

variable "instance_count" {
  default = "2"
}

## VPC creation
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Name" = "${var.project}-VPC"
  }
}

## Subnets creation - Public
resource "aws_subnet" "public" {
  count = length(var.subnet_cidrs_public)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet_cidrs_public[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project}-public"
  }
  depends_on = [ aws_vpc.vpc ]
}

## Subnets creation - Private
resource "aws_subnet" "private" {
  count = length(var.subnet_cidrs_private)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet_cidrs_private[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.project}-private"
  }
  depends_on = [ aws_vpc.vpc ]
}

## Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
 
  tags = {
    "Name" = "${var.project}-IGW"
  }
  depends_on = [ aws_vpc.vpc ]
}

# Nat Gateway
resource "aws_eip" "natgw" {
  vpc      = true
}
 
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw.id
  subnet_id = aws_subnet.public[0].id
  tags = {
    Name = "${var.project}-NATGW"
  }
  depends_on = [ aws_internet_gateway.igw ]
}

## Route Table - Private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "${var.project}-privateroute"
  }
  depends_on = [ aws_nat_gateway.natgw ]
}
 
## Route Table - Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.project}-publicroute"
  }
  depends_on = [ aws_internet_gateway.igw ]
}

## Route table associations - Public
resource "aws_route_table_association" "public" {
  count = length(var.subnet_cidrs_public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
  depends_on = [ aws_route_table.public ]
}

## Route table associations - Private
resource "aws_route_table_association" "private" {
  count = length(var.subnet_cidrs_private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
  depends_on = [ aws_route_table.private ]
}

## EC2 Security Group
resource "aws_security_group" "ec2-security-group" {
    name        = "ec2-security-group"
    description = "Security group to allow traffic to/from EC2"
    vpc_id      = aws_vpc.vpc.id
 
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "${var.project}-ec2-security-group"
    }
    depends_on = [ aws_vpc.vpc ]
}

## EC2 Instances create - Based on count variable (If more instanes needed, increment count variable)
## Using AMI ami-0742b4e673072066f - Linux for below

resource "aws_instance" "ec2instances" {
  count = var.instance_count
  ami           = "ami-0742b4e673072066f"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2-security-group.id]
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  tags = {
    Name = "${format("Instance%02d", count.index + 1)}"
  }
  depends_on = [ aws_security_group.ec2-security-group,aws_route_table_association.private ]
}
