resource "aws_ecr_repository" "front_salon" {
  name                 = var.front_repo
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "Front Salon Repo"
    Environment = "dev"
  }
}
