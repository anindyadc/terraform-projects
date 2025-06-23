module "vpc" {
  source              = "../../../shared-modules/vpc"
  name                = "alb-vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone   = "us-east-1a"
  enable_nat_gateway  = true
}

resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = module.vpc.vpc_id

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

resource "aws_security_group" "db_sg" {
  name   = "db-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  # ✅ Allow SSH from App SG
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

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP traffic from internet"
  vpc_id      = module.vpc.vpc_id

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


module "app_instance_1" {
  source              = "../../../shared-modules/ec2"
  name                = "app1"
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  key_name              = var.key_name
  subnet_id           = module.vpc.public_subnet_id
  associate_public_ip = true
  user_data           = file("user_data_app.sh")
  security_group_ids  = [aws_security_group.app_sg.id]
}

module "app_instance_2" {
  source              = "../../../shared-modules/ec2"
  name                = "app2"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  subnet_id           = module.vpc.public_subnet_id
  associate_public_ip = true
  key_name            = var.key_name
  user_data           = file("user_data_app.sh")
  security_group_ids  = [aws_security_group.app_sg.id]
}

module "db_instance" {
  source                = "../../../shared-modules/ec2"
  name                  = "db-node"
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  key_name              = var.key_name
  subnet_id             = module.vpc.private_subnet_id
  associate_public_ip   = false
  user_data             = file("user_data_db.sh")
  security_group_ids  = [aws_security_group.db_sg.id]
}

module "alb" {
  source              = "../../../shared-modules/alb"
  name                = "app-alb"
  vpc_id              = module.vpc.vpc_id
  subnets = [
    module.vpc.public_subnet_ids[0],
    module.vpc.public_subnet_ids[1]
  ]
  security_groups     = [aws_security_group.alb_sg.id]
  target_ids = [
  module.app_instance_1.instance_id,
  module.app_instance_2.instance_id
  ]
}
