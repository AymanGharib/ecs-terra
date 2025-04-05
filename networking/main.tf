// VPC
resource "aws_vpc" "cluster" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  lifecycle {
    create_before_destroy = true
  }
}

// Get AZs
data "aws_availability_zones" "available" {}

resource "random_shuffle" "list_azs" {
  input        = data.aws_availability_zones.available.names
  result_count = 2 
}

// Public Subnet
resource "aws_subnet" "public_subnet" {

  count                   = 2
  vpc_id                  = aws_vpc.cluster.id
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.list_azs.result[count.index]


  tags = {

    Name = "terra-public-${count.index + 1}"
  }
}
// Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.cluster.id
  cidr_block              = var.private_subnet_cidr[0]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.list_azs.result[1]

  tags = {
    Name = "Private Subnet"
  }
}

// Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cluster.id

  tags = {
    Name = "ecs IGW"
  }
}

// Public Route Table (for internet access)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cluster.id
}

// Route for Public Subnet -> Internet
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

// Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_assoc" {
    count      = 2  
  subnet_id  = aws_subnet.public_subnet[count.index].id  # Accessing using count.index
  route_table_id = aws_route_table.public_rt.id
}

// Private Route Table (No Internet)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.cluster.id
}

// Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}


// set up security groups

resource "aws_security_group" "master_node_sg" {
  name        = "master-node-sg"
  description = "Security group for Kubernetes master node"
  vpc_id      = aws_vpc.cluster.id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress  {

    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }



  // Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb Security Group"
  }
}




resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Security group for frontend ECS service"
  vpc_id      = aws_vpc.cluster.id

  # Allow inbound traffic from the ALB's security group
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.master_node_sg.id]  # Allow traffic from ALB SG
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound traffic to anywhere
  }

  tags = {
    Name = "Frontend ECS Security Group"
  }
}
