#-------EC2 Instance -----------
resource "aws_instance" "EC2_instance" {
  ami           = var.image
  instance_type = var.instance_type
  root_block_device {
    volume_size = var.EBS_size
  }
  key_name                    = var.key_name
  vpc_security_group_ids      = var.SG_ID
  subnet_id                   = var.subnet_ID
  associate_public_ip_address = var.EC2_Public_IP
  user_data                   = var.user_data
  tags = {
    Name = var.EC2_name
  }
}