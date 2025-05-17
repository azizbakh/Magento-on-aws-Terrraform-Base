resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project}-db-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier              = "${var.project}-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.instance_class
  allocated_storage       = 20
  max_allocated_storage   = 100
  storage_type            = "gp2"
  username                = var.db_user
  password                = var.db_password
  db_name                 = var.db_name
  port                    = 3306
  vpc_security_group_ids  = [var.mysql_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.this.name
  publicly_accessible     = false
  multi_az                = true
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name = "${var.project}-mysql"
  }
}
