resource "docker_image" "backend" {
  name = "${var.repository_url}:latest"

  build {
    context    = "${path.module}/"
    dockerfile = "Dockerfile"

    build_arg = {
      DB_HOST = var.db_endpoint
      DB_USER = var.db_user
      DB_PASS = var.db_pass
  }
}

}