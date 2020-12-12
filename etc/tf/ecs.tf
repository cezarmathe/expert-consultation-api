# expert-consultation-api - ecs

locals {
  main_ecs_task_definition = [
    {
      name   = "legal-client"
      image  = "${aws_ecr_repository.client.repository_url}:latest"
      cpu    = 512
      memory = 1024
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          awslogs-group         = aws_cloudwatch_log_group.main.name
          awslogs-region        = data.aws_region.main.name
          awslogs-stream-prefix = "client"
        }
      }
    },
    {
      name   = "legal-api"
      image  = "${aws_ecr_repository.api.repository_url}:latest"
      cpu    = 512
      memory = 1024
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          awslogs-group         = aws_cloudwatch_log_group.main.name
          awslogs-region        = data.aws_region.main.name
          awslogs-stream-prefix = "api"
        }
      }
      secrets = [
        {
          name      = "MYSQL_DB_USERNAME"
          valueFrom = "arn:aws:ssm:${data.aws_region.main.name}:${data.aws_caller_identity.main.account_id}:parameter/legalconsultation/MYSQL_DB_USERNAME"
        },
        {
          name      = "MYSQL_DB_PASSWORD"
          valueFrom = "arn:aws:ssm:${data.aws_region.main.name}:${data.aws_caller_identity.main.account_id}:parameter/legalconsultation/MYSQL_DB_PASSWORD"
        },
        {
          name      = "MYSQL_DB_URL"
          valueFrom = "arn:aws:ssm:${data.aws_region.main.name}:${data.aws_caller_identity.main.account_id}:parameter/legalconsultation/MYSQL_DB_URL"
        },
      ]
    },
    {
      name      = "mailhog"
      essential = true
      image     = "mailhog/mailhog:latest"
      cpu       = 1024
      memory    = 2048
      portMappings = [
        {
          containerPort = 1025
          hostPort      = 1025
        },
        {
          containerPort = 8025
          hostPort      = 8025
        },
      ]
    },
  ]
}

resource "aws_ecr_repository" "client" {
  name = var.client_image
}

# ???
# - name: Tag and push client image
#   docker_image:
#   name: "{{ client_image }}"
#   repository: "{{ client_repo.repository.repositoryUri }}"
#   tag: "latest"
#   push: yes
#   source: local

# resource "docker_registry_image" "client" {
#   name = "helloworld:1.0"

#   build {
#     context = "pathToContextFolder"
#   }
# }

resource "aws_ecr_repository" "api" {
  name = var.api_image
}

# ???
# - name: Tag and push api image
#   docker_image:
#   name: "{{ api_image }}"
#   repository: "{{ api_repo.repository.repositoryUri }}"
#   tag: "latest"
#   push: yes
#   source: local

# resource "docker_registry_image" "api" {
#   name = "helloworld:1.0"

#   build {
#     context = "pathToContextFolder"
#   }
# }

resource "aws_ecs_task_definition" "main" {
  family                = "legal-consult-task"
  container_definitions = jsonencode(local.main_ecs_task_definition)

  requires_compatibilities = ["FARGATE"]

  cpu          = 1024
  memory       = 2048
  network_mode = "awsvpc"
}

resource "aws_ecs_cluster" "main" {
  name = "legal-consult-cluster"
}

resource "aws_ecs_service" "main" {
  name            = "legal-consult-cluster-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.web.id]
    subnets          = [aws_subnet.public.id]
  }
}
