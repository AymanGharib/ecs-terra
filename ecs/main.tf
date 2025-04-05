resource "aws_ecs_cluster" "frontend_cluster" {
  name = "frontend-cluster"
}


resource "aws_ecs_task_definition" "frontend_task" {
  count = var.tasks_count
  family                   = "3-tier-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.role_arn

container_definitions = jsonencode([
  {
    name      = var.image[count.index].name
    image     = var.image[count.index].url
    essential = true

    portMappings = var.image[count.index].name == "frontend" ? [
      {
        containerPort = 80
        protocol      = "tcp"
      }
    ] : [
      {
        containerPort = 8080
        protocol      = "tcp"
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/frontend"
        awslogs-region        = "eu-north-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }
])

}







resource "aws_ecs_service" "frontend_service" {
  
  name            = "frontend-service"
  cluster         = aws_ecs_cluster.frontend_cluster.id
  launch_type     = "FARGATE"
  task_definition =  aws_ecs_task_definition.frontend_task[0].arn
  desired_count   = 1

  network_configuration {
    subnets         = var.public_subnets
    assign_public_ip = true
    security_groups = [var.alb_sg]
  }

  load_balancer {
    target_group_arn = var.alb_tg_arn
    container_name   = "frontend"
    container_port   = 80
  }


}

