environment = "dev"

instance_type = "t3.micro"

asg_min_size         = 2
asg_desired_capacity = 2
asg_max_size         = 4

vpc_cidr = "10.0.0.0/16"

public_subnet_a_cidr = "10.0.1.0/24"
public_subnet_b_cidr = "10.0.2.0/24"

private_app_subnet_a_cidr = "10.0.11.0/24"
private_app_subnet_b_cidr = "10.0.12.0/24"

private_db_subnet_a_cidr = "10.0.21.0/24"
private_db_subnet_b_cidr = "10.0.22.0/24"