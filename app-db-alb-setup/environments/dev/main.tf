provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24"]
  enable_nat_gateway   = true
}

# Security group for app
resource "aws_security_group" "app_sg" {
  name_prefix = "app-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

# Security group for DB (includes port 22)
resource "aws_security_group" "db_sg" {
  name_prefix = "db-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

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

# App instances
module "app_instance_1" {
  source              = "../../../shared-modules/ec2"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc.public_subnet_ids[0]
  security_group_ids  = [aws_security_group.app_sg.id]
  key_name            = var.key_name
  name                = "app-instance-1"
  associate_public_ip = true
  user_data           = file("user_data_app.sh")
}

module "app_instance_2" {
  source              = "../../../shared-modules/ec2"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc.public_subnet_ids[1]
  security_group_ids  = [aws_security_group.app_sg.id]
  key_name            = var.key_name
  name                = "app-instance-2"
  associate_public_ip = true
  user_data           = file("user_data_app.sh")
}

# DB instance
module "db_instance" {
  source              = "../../../shared-modules/ec2"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc.private_subnet_ids[0]
  security_group_ids  = [aws_security_group.db_sg.id]
  key_name            = var.key_name
  name                = "db-instance"
  associate_public_ip = false
  user_data           = file("user_data_db.sh")
}

# ALB
module "alb" {
  source           = "../../../shared-modules/alb"
  name             = "app-alb"
  vpc_id           = module.vpc.vpc_id
  subnets          = module.vpc.public_subnet_ids
  security_groups  = [aws_security_group.app_sg.id]
  target_ids       = [
    module.app_instance_1.instance_id,
    module.app_instance_2.instance_id
  ]
}
