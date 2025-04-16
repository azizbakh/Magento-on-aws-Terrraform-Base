variable "project" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "key_name" {
  type = string
}

variable "ec2_sg_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "efs_id" {
  type = string
}

variable "db_endpoint" {
  type = string
}

variable "redis_host" {
  type = string
}

variable "es_host" {
  type = string
}
