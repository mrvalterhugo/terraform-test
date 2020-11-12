aws_profile     = "default"
aws_region      = "eu-west-2"
vpc_cidr        = "192.168.0.0/16"
localip         = ["0.0.0.0/0"]
key_name        = "dockerk"
WEB_domain      = "web.valterschmaltz.com"
user_data       = "userdata"
route53-zone-id = "Z057712710J22FLTHOT0J"

DNS = {
  bastion = "dev-host"
  ELB     = "web"
}

instance_type = {
  nano   = "t2.nano"
  micro  = "t2.micro"
  small  = "t2.small"
  medium = "t2.medium"
  large  = "t2.large"
  xlarge = "t2.xlarge"
}
cidrs = {
  ELB_public_subnet_1     = "192.168.10.0/24"
  ELB_public_subnet_2     = "192.168.20.0/24"
  bastion_public_subnet_1 = "192.168.30.0/24"
  WEB_private_subnet_1    = "192.168.40.0/24"
  WEB_private_subnet_2    = "192.168.50.0/24"
}

images = {
  debian       = "ami-0ef2c681c6c4ff0e9"
  ubuntu       = "ami-05c424d59413a2876"
  amazon-linux = "ami-0a669382ea0feb73a"
  redhat       = "ami-0fc841be1f929d7d1"
}