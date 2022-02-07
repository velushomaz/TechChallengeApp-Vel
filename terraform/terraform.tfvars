# Account Vars
region             = "ap-southeast-2"
availability_zones = ["ap-southeast-2a", "ap-southeast-2b"] # must be at least 2

# Subnet Vars
public_subnet_blocks = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

rds_subnet_blocks = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

ec2_subnet_blocks = [
  "10.0.21.0/24",
  "10.0.22.0/24"
]

# Database Vars
rds_instance_identifier = "servian-postgresql"
database_name           = "app"
database_user           = "postgres"
listen_host             = "0.0.0.0"

# ALB allowed CIDR blocks
# allowed_alb_cidr_blocks = ["0.0.0.0/0"]

# EC2 Vars
amis = {
  # Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
  "ap-southeast-2" = "ami-0c635ee4f691a2310"
}
instance_type              = "t2.micro"
autoscaling_group_min_size = 1
autoscaling_group_max_size = 1