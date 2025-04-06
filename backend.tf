terraform {
  cloud {

    organization = "FSTT"

    workspaces {
      name = "ecs-terra"
    }
  }
}