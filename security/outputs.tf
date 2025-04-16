output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "mysql_sg_id" {
  value = aws_security_group.mysql_sg.id
}

output "redis_sg_id" {
  value = aws_security_group.redis_sg.id
}

output "es_sg_id" {
  value = aws_security_group.es_sg.id
}
