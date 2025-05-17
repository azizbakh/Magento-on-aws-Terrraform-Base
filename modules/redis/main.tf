resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project}-redis-subnet-group"
  }
}

resource "aws_elasticache_parameter_group" "redis7" {
  name   = "${var.project}-redis7-parameter-group"
  family = "redis7"
  description = "Custom parameter group for Redis 7"
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.project}-redis"
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = 1
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = [var.redis_sg_id]

  tags = {
    Name = "${var.project}-redis"
  }
}
