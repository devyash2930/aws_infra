resource "aws_ecr_repository" "tfer--creamandonion" {
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "false"
  }

  image_tag_mutability = "MUTABLE"
  name                 = "creamandonion"
  region               = "us-east-1"
}

resource "aws_ecr_repository" "tfer--hack-postgres" {
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "false"
  }

  image_tag_mutability = "MUTABLE"
  name                 = "hack-postgres"
  region               = "us-east-1"
}

resource "aws_ecr_repository" "tfer--mock-api" {
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "false"
  }

  image_tag_mutability = "MUTABLE"
  name                 = "mock-api"
  region               = "us-east-1"
}
