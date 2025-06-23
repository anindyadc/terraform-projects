module "webapp_ecs" {
  source          = "../../modules/webapp_ecs"
  name            = "my-webapp"
  image           = "123456789.dkr.ecr.us-east-1.amazonaws.com/webapp:v1"
  container_port  = 8080
  region          = "us-east-1"
}
