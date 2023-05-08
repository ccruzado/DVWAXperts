module "ecs_cluster" {
  source        = "terraform-aws-modules/ecs/aws"
  cluster_name  = "ecs-fargate-dvwa"

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

module "ecs_service" {
  source      = "terraform-aws-modules/ecs/aws//modules/service"
  name        = "ecs-service-dvwa"
  cluster_arn = module.ecs_cluster.cluster_arn

  cpu    = 1024
  memory = 4096

  # Container definition(s)
  container_definitions = {
    dvwa = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = "vulnerables/web-dvwa"
      port_mappings = [
        {
          name          = "dvwa"
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  }
  load_balancer = {
    service = {
      target_group_arn = element(module.alb.target_group_arns, 0)
      container_name   = "dvwa"
      container_port   = 80
    }
  }

  subnet_ids = [aws_subnet.dvwa-vpc-priv1.id,aws_subnet.dvwa-vpc-priv2.id]
  security_group_rules = {
    alb_ingress = {
      type                     = "ingress"
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.sgr-alb.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
module "sgr-alb" {
  source  = "terraform-aws-modules/security-group/aws"
  
  name        = "sgr-dvwa-alb"
  description = "sgr-dvwa-alb"
  vpc_id      = aws_vpc.dvwa-vpc.id

  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  
  name = "alb-dvwa"

  load_balancer_type = "application"

  vpc_id          = aws_vpc.dvwa-vpc.id
  subnets         = [aws_subnet.dvwa-vpc-pub1.id,aws_subnet.dvwa-vpc-pub2.id]
  security_groups = [module.sgr-alb.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name             = "tg-alb-dvwa"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "ip"
    },
  ]
}
