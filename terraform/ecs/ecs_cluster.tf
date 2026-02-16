resource "aws_ecs_cluster" "tfer--creamandonion" {
  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  name   = "creamandonion"
  region = "us-east-1"

  setting {
    name  = "containerInsights"
    value = "enhanced"
  }
}
