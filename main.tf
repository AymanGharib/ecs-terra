module "aws_ecr_repositories" {
  source = "./ecr-repo"
  
  repos_count = var.repos_count
  repo = var.repos
}
module "networking" {
  source              = "./networking"
  cidr_block          = var.cidr_block
 public_subnet_cidr  = [for i in [0, 1] : cidrsubnet(var.cidr_block, 8, i)]
private_subnet_cidr = [cidrsubnet(var.cidr_block, 8, 2)]




}

module "load_balancer" {
  source = "./alb"
  vpc_id = module.networking.vpc_id
  security_groups = module.networking.alb_sg
  subnets = module.networking.public_subnet_id

}

module "ecs"  {
depends_on = [ module.load_balancer ]
  source = "./ecs"
  role_arn = module.iam.role_arn
public_subnets = module.networking.public_subnet_id
alb_sg = module.networking.alb_sg
alb_tg_arn = module.load_balancer.tg_arn
tasks_count = 2
image  =  var.image


}
module "iam" {
  source = "./iam"
}


module "database" {
  source = "./database"
   
  db_engine_version      = "8.0.40"
  db_instance_class      = "db.t3.micro"
  dbname                 = var.db_name

  db_identifier          = "three-tier-db"
  skip_db_snapshot       = true
  db_subnet_group_name   =  module.networking.db_subnet
  vpc_security_group_ids =  module.networking.db_sg
}



