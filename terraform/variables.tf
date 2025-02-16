variable "region" {
  default = "<region>"
}

variable "access_key" {
  default = "<access_key>"
}

variable "secret_key" {
  default = "<secret_key>"
}

variable "vpc_name" {
  default = "my-demo-vpc"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_name_a" {
  default = "public-subnet-a"
}

variable "public_subnet_name_b" {
  default = "public-subnet-b"
}

variable "app_private_subnet_a" {
  default = "app-private-subnet-a"
}

variable "app_private_subnet_b" {
  default = "app-private-subnet-b"
}

variable "db_private_subnet_a" {
  default = "db-private-subnet-a"
}

variable "db_private_subnet_b" {
  default = "db-private-subnet-b"
}

variable "internet_gateway_name" {
  default = "demo-igw"
}

variable "public_route_table_name" {
  default = "public-route-table"
}

variable "private_route_table_name" {
  default = "private-route-table"
}

variable "nat_gateway_name" {
  default = "demo-nat-gateway"
}

variable "rds_security_group_name" {
  default = "rds_security_group"
}

variable "rds_security_group_description" {
  default = "Example for security group for RDS created by terraform"
}

variable "engine" {
  default = "postgres"
}

variable "rds_instance_class" {
  default = "db.t4g.micro"
}

variable "db_identifier" {
  default = "demo_db"
}

variable "db_name" {
  default = "demo-db"
}

variable "initial_db_name" {
  default = social_db
}

variable "username" {
  default = "postgres"
}

variable "password" {
  default = "password7452"
}

variable "app_security_group_name" {
  default = "app_security_group"
}

variable "app_security_group_description" {
  default = "Example for security group for Application layer created by terraform"
}

variable "fe_security_group_name" {
  default = "fe_security_group"
}

variable "fe_security_group_description" {
  default = "Example for security group for FE layer created by terraform"
}

variable "alb_security_group_name" {
  default = "alb_security_group"
}

variable "alb_security_group_description" {
  default = "Example for security group for ALB created by terraform"
}