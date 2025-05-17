resource "aws_efs_file_system" "this" {
  creation_token = "${var.project}-efs"

  tags = {
    Name = "${var.project}-efs"
  }
}

resource "aws_efs_mount_target" "targets" {
  count          = length(var.private_subnet_ids)
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = var.private_subnet_ids[count.index]
  security_groups = [var.ec2_sg_id]
}
