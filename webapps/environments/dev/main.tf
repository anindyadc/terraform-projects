provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "ec2_sg" {
  name   = "allow-ssh"
  vpc_id = module.vpc.vpc_id

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
}

module "vpc" {
  source               = "../../modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidr   = "10.0.1.0/24"
  availability_zone    = "us-east-1a"
  name                 = "dev"
}

module "ec2" {
  source             = "../../modules/ec2"
  ami_id             = "ami-0c02fb55956c7d316"  # Amazon Linux 2 AMI (change per region)
  instance_type      = "t2.micro"
  subnet_id          = module.vpc.subnet_id
  security_group_ids = [aws_security_group.ec2_sg.id]
  key_name           = "myintellinux.pem"  # Replace with your key pair
  name               = "dev-instance"
}
