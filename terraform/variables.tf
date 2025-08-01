variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for second private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone_1" {
  description = "AZ for public subnet"
  type        = string
  default     = "eu-north-1a"
}

variable "availability_zone_2" {
  description = "AZ for private subnet"
  type        = string
  default     = "eu-north-1b"
}

variable "key_pair_name" {
  description = "Name of the AWS EC2 key pair"
  type        = string
}

variable "db_password" {
  description = "Password for RDS"
  type        = string
  sensitive   = true
}


variable "rds_port" {
  description = "RDS port"
  type        = number
  default     = 5432
}

variable "rds_user" {
  description = "RDS username"
  type        = string
}

variable "rds_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
}

variable "rds_db" {
  description = "RDS database name"
  type        = string
}
variable "db_username" {
  description = "Username for RDS"
  type        = string
}

