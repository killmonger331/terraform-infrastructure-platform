module "networking" {
  source = "../../modules/networking"

  environment = var.environment
}

module "compute" {
  source = "../../modules/compute"

  environment = var.environment

  vpc_id = module.networking.vpc_id

  public_subnet_ids      = module.networking.public_subnet_ids
  private_app_subnet_ids = module.networking.private_app_subnet_ids

  alb_security_group_id = module.networking.alb_security_group_id
  ec2_security_group_id = module.networking.ec2_security_group_id

  instance_type    = "t3.micro"
  min_size         = 2
  desired_capacity = 2
  max_size         = 4
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