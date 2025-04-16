variable "name" {
  description = "Nom du ALB"
  type        = string
}

variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "Liste des IDs de subnets publics"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Liste des Security Groups associés au ALB"
  type        = list(string)
}
