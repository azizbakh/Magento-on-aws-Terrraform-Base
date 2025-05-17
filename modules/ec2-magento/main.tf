resource "aws_launch_template" "magento" {
  name_prefix   = "${var.project}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.ec2_sg_id]
  key_name               = var.key_name

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    efs_id        = var.efs_id
    db_endpoint   = var.db_endpoint
    redis_host    = var.redis_host
    es_host       = var.es_host
  }))

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project}-magento"
    }
  }
}

resource "aws_autoscaling_group" "magento" {
  name                      = "${var.project}-asg"
  vpc_zone_identifier       = var.public_subnet_ids
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 2
  health_check_type         = "EC2"
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.magento.arn]

  launch_template {
    id      = aws_launch_template.magento.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-magento"
    propagate_at_launch = true
  }
}

resource "aws_lb" "this" {
  name               = "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.project}-alb"
  }
}

resource "aws_lb_target_group" "magento" {
  name     = "${var.project}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project}-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.magento.arn
  }
}
