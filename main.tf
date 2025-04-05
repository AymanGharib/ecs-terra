module "aws_ecr_repositories" {
  source = "./ecr-repo"
  front_repo = "front-salon"
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
front_image = var.front_image
}
module "iam" {
  source = "./iam"
}




