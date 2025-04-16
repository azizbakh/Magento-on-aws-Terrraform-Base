resource "aws_opensearch_domain" "this" {
  domain_name           = "${var.project}-es"
  engine_version        = "OpenSearch_1.3"

  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 20
    volume_type = "gp2"
  }

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = "*"
      Action = "es:*"
      Resource = "arn:aws:es:${var.region}:${var.account_id}:domain/${var.project}-es/*"
    }]
  })

  vpc_options {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.es_sg_id]
  }

  tags = {
    Name = "${var.project}-es"
  }
}
