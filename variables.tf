variable "cidr_block" {
  default = "10.123.0.0/16"
}
variable "front_image" {
  
    default = "216874796625.dkr.ecr.eu-north-1.amazonaws.com/front-salon:latest"
  
}
variable "repos_count" {
  default = 2
}
variable "repos" {
  default = ["front-salon", "backend"]
}

variable "image" {
  default = [{ "name" : "frontend" ,  "url" : "216874796625.dkr.ecr.eu-north-1.amazonaws.com/front-salon:latest"}  ,{ "name" : "backend" ,  "url" : "216874796625.dkr.ecr.eu-north-1.amazonaws.com/backend:latest"}  ]
}
variable "db_name" {
  default = "salondb"
}