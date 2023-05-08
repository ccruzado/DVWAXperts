module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws"
  cluster_name = "ecs-fargate-dvwa"

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }
}