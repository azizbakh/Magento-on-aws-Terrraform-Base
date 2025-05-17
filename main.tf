terraform {
  required_version = "1.11.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source               = "./modules/vpc"
  project              = var.project
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnets
  private_subnet_cidrs = var.private_subnets
}

module "security" {
  source  = "./modules/security"
  project = var.project
  vpc_id  = module.vpc.vpc_id
}

module "rds" {
  source             = "./modules/rds"
  project            = var.project
  private_subnet_ids = module.vpc.private_subnet_ids
  mysql_sg_id        = module.security.mysql_sg_id
  db_user            = var.db_user
  db_password        = var.db_password
  db_name            = var.db_name
}

module "redis" {
  source             = "./modules/redis"
  project            = var.project
  private_subnet_ids = module.vpc.private_subnet_ids
  redis_sg_id        = module.security.redis_sg_id
}

module "efs" {
  source             = "./modules/efs"
  project            = var.project
  private_subnet_ids = module.vpc.private_subnet_ids
  ec2_sg_id          = module.security.ec2_sg_id
}

module "elasticsearch" {
  source             = "./modules/elasticsearch"
  project            = var.project
  region             = var.region
  account_id         = var.account_id
  private_subnet_ids = module.vpc.private_subnet_ids
  es_sg_id           = module.security.es_sg_id
}

module "ec2" {
  source            = "./modules/ec2-magento"
  project           = var.project
  ami_id            = var.ami_id
  key_name          = var.key_name
  instance_type     = var.instance_type
  ec2_sg_id         = module.security.ec2_sg_id
  alb_sg_id         = module.security.alb_sg_id
  public_subnet_ids = module.vpc.public_subnet_ids
  vpc_id            = module.vpc.vpc_id
  efs_id            = module.efs.efs_id
  db_endpoint       = module.rds.db_endpoint
  redis_host        = module.redis.redis_endpoint
  es_host           = module.elasticsearch.es_endpoint
}
