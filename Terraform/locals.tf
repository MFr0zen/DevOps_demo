locals {
  region      = "eu-central-1"
  environment = "demo"

  vpc_name = "vpc"
  vpc_cidr = "10.0.0.0/16"


  pubsubnet_name     = "publicSubnet"
  availability_zones = ["eu-central-1a", "eu-central-1b"]
  public_subnets     = ["10.0.0.0/19", "10.0.32.0/19"]

  pubrout_name = "publicRT"


  private_subnests = {
    public_1 = {
      cidr              = cidrsubnet(local.vpc_cidr, 3, 2)
      availability_zone = local.availability_zones[0]
      prsubnet_name     = "privateSubnet1"
    }
    public_2 = {
      cidr              = cidrsubnet(local.vpc_cidr, 3, 3)
      availability_zone = local.availability_zones[1]
      prsubnet_name     = "privateSubnet2"
    }
  }

  ecr_name    = "ecr_repo"
  igw_name    = "igw"
  nat_name    = "nat"
  prrout_name = "privateRT"

  ingress_rules = {
    22 : "63.10.10.10/32"
    80 : "0.0.0.0/0"
  }

  sg_name = "vpc_sg"

  instance_type = "t3.micro"
  instance_name = "dev_app"

  ec2_sg_name = "dev_apps_sg"

  load_balancer_type = "application"
  load_balancer_name = "dev-app-loadbalancer"

  target_group_name = "app-target-group"
  ec2_role_name     = "ec2_role"

  ec2_ecr_profile = "ec2-ecr-profile"

  app_port = 8000

  image_tags_name      = "/my-apps/demodevops/image_tag"
  image_tags_value     = "v1.0.1"
  image_tags_data_type = "text"
}