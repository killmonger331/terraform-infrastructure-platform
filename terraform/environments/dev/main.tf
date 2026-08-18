module "compute" {
  source = "../../modules/compute"

  environment = var.environment

  vpc_id = module.networking.vpc_id

  public_subnet_ids      = module.networking.public_subnet_ids
  private_app_subnet_ids = module.networking.private_app_subnet_ids

  alb_security_group_id = module.networking.alb_security_group_id
  ec2_security_group_id = module.networking.ec2_security_group_id

  instance_type    = var.instance_type
  min_size         = var.asg_min_size
  desired_capacity = var.asg_desired_capacity
  max_size         = var.asg_max_size
}

module "database" {
  source = "../../modules/database"

  environment = var.environment

  private_db_subnet_ids = module.networking.private_db_subnet_ids
  rds_security_group_id = module.networking.rds_security_group_id
}

module "monitoring" {
  source = "../../modules/monitoring"

  environment = var.environment
  aws_region  = "us-east-1"

  autoscaling_group_name  = module.compute.autoscaling_group_name
  alb_arn_suffix          = module.compute.alb_arn_suffix
  target_group_arn_suffix = module.compute.target_group_arn_suffix

  db_instance_identifier = module.database.db_instance_identifier
}

module "networking" {
  source = "../../modules/networking"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr

  public_subnet_a_cidr      = var.public_subnet_a_cidr
  public_subnet_b_cidr      = var.public_subnet_b_cidr
  private_app_subnet_a_cidr = var.private_app_subnet_a_cidr
  private_app_subnet_b_cidr = var.private_app_subnet_b_cidr
  private_db_subnet_a_cidr  = var.private_db_subnet_a_cidr
  private_db_subnet_b_cidr  = var.private_db_subnet_b_cidr
}