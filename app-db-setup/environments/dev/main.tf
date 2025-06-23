provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "../../../shared-modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24"]
  enable_nat_gateway   = true
}

resource "aws_security_group" "app_sg" {
  vpc_id = module.vpc.vpc_id
  name_prefix = "app-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_security_group" "db_sg" {
  vpc_id = module.vpc.vpc_id
  name_prefix = "db-sg"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "app_instance" {
  source              = "../../../shared-modules/ec2"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc.public_subnet_ids[0]
  security_group_ids  = [aws_security_group.app_sg.id]
  associate_public_ip = true
  key_name            = var.key_name
  name                = "app-instance"
  user_data           = file("user_data_app.sh")
}

module "db_instance" {
  source              = "../../../shared-modules/ec2"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc.private_subnet_ids[0]
  security_group_ids  = [aws_security_group.db_sg.id]
  associate_public_ip = false
  key_name            = var.key_name
  name                = "db-instance"
  user_data           = file("user_data_db.sh")
}
