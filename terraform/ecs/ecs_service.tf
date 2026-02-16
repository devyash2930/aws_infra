resource "aws_ecs_service" "tfer--creamandonion_cream-task-service" {
  availability_zone_rebalancing = "ENABLED"

  capacity_provider_strategy {
    base              = "0"
    capacity_provider = "FARGATE"
    weight            = "1"
  }

  cluster = "creamandonion"

  deployment_circuit_breaker {
    enable   = "true"
    rollback = "true"
  }

  deployment_configuration {
    bake_time_in_minutes = "0"
    strategy             = "ROLLING"
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "100"
  desired_count                      = "1"
  enable_ecs_managed_tags            = "true"
  enable_execute_command             = "false"
  health_check_grace_period_seconds  = "0"

  load_balancer {
    container_name   = "cream-container"
    container_port   = "8000"
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:244996607989:targetgroup/cream-task-tg/e42becd8ade6596e"
  }

  name = "cream-task-service"

  network_configuration {
    assign_public_ip = "true"
    security_groups  = ["sg-07866c7936a11413f", "sg-05cc039b44500d695"]
    subnets          = ["${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-039d543fb4112a8ce_id}", "${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-00cbacb8e04e4897a_id}", "${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-035c1896d7e7fcbb0_id}", "${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-0aa656b5a871427ee_id}", "${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-04ebabf9e4eaf3bec_id}", "${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-03d875e3a4cc4fa70_id}"]
  }

  platform_version    = "1.4.0"
  region              = "us-east-1"
  scheduling_strategy = "REPLICA"
  task_definition     = "arn:aws:ecs:us-east-1:244996607989:task-definition/cream-task:52"
}
