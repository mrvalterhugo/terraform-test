#------ Launch Configuration-------------
resource "aws_launch_configuration" "ASG_launch_conf" {
  name                        = var.ASG_launch_config_name
  image_id                    = var.image
  instance_type               = var.instance_type
  key_name                    = var.key_name
  user_data                   = var.user_data
  associate_public_ip_address = false
  security_groups             = var.SG_ID
}
#------Auto-Scaling------------
resource "aws_autoscaling_group" "WEB_ASG" {
  name                      = var.ASG_name
  max_size                  = var.ASG_max_size
  min_size                  = var.ASG_min_size
  health_check_grace_period = 300
  health_check_type         = var.health_check_type
  desired_capacity          = var.ASG_desired_capacity
  force_delete              = var.ASG_force_delete
  launch_configuration      = aws_launch_configuration.ASG_launch_conf.name
  vpc_zone_identifier       = var.ASG_VPC_Zone
  target_group_arns         = var.ELB_TG_ARN
  tag {
    key                 = "Name"
    value               = var.instance-name-tag
    propagate_at_launch = true
  }
  timeouts {
    delete = "15m"
  }
  depends_on = [var.depends-on]
}