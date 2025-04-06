output "backend_repo_url"{
  value = aws_ecr_repository.front_salon[1].repository_url
}