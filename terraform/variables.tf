# AWS account variables
variable "access_key" {
  sensitive = true
}
variable "secret_key" {
  sensitive = true
}
variable "region" {}
variable "public_key_path" {}
variable "backend_bucket" {}

# Subnet Vars
variable "availability_zones" {}
variable "public_subnet_blocks" {}
variable "rds_subnet_blocks" {}
variable "ec2_subnet_blocks" {}

# Database variables
variable "rds_instance_identifier" {}
variable "database_name" {}
variable "database_password" {
  sensitive = true
}
variable "database_user" {}
variable "listen_host" {}

# ALB variables
variable "allowed_alb_cidr_blocks" {
  type = list(string)
}

# EC2 variables
variable "amis" {
  type = map(string)
}
variable "allowed_ec2_ssh_cidr_blocks" {
  type = list(string)
}
variable "instance_type" {}
variable "autoscaling_group_min_size" {}
variable "autoscaling_group_max_size" {}