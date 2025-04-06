terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
     docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}




provider "docker" {}