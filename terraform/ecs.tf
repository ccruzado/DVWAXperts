module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  name = "ecs-fargate-dvwa"
  container_insights = true
  capacity_providers = ["FARGATE"]
  tags = {
    Environment = "Development"
  }
}