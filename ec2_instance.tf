# Importing aws provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure aws provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC (Note: "myvpc" is NOT what it will be named in AWS Console, it is internal only)
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  # This is how you name your VPC within AWS
  tags = {
    Name = "lab_VPC"
  }
}

# Create VPC Subnet
resource "aws_subnet" "mysubnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "lab_subnet"
  }
}

# Create Network Interface
resource "aws_network_interface" "mynic" {
  subnet_id   = aws_subnet.mysubnet.id
  private_ips = ["10.0.1.25"]

  tags = {
    Name = "lab_network_interface"
  }
}

# Create EC2 Instance
resource "aws_instance" "server1" {
  ami           = "ami-0c7af5fe939f2677f" # RHEL 9 free tier
  instance_type = "t2.micro"              # Free tier

  network_interface {
    network_interface_id = aws_network_interface.mynic.id
    device_index         = 0
  }

  tags = {
    Name = "RHEL9"
  }
}