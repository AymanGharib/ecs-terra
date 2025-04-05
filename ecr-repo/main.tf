resource "aws_ecr_repository" "front_salon" {
  count = var.repos_count
  name                 = var.repo[count.index]
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.repo[count.index]}Repo"
    Environment = "dev"
  }
}
