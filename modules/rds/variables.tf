variable "project" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "mysql_sg_id" {
  type = string
}

variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type = string
}
