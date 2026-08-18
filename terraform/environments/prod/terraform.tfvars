environment = "prod"

instance_type = "t3.small"

asg_min_size         = 2
asg_desired_capacity = 2
asg_max_size         = 6

vpc_cidr = "10.1.0.0/16"

public_subnet_a_cidr = "10.1.1.0/24"
public_subnet_b_cidr = "10.1.2.0/24"

private_app_subnet_a_cidr = "10.1.11.0/24"
private_app_subnet_b_cidr = "10.1.12.0/24"

private_db_subnet_a_cidr = "10.1.21.0/24"
private_db_subnet_b_cidr = "10.1.22.0/24"