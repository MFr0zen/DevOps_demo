variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "aws_ecr_name" {
  type    = string
  default = "ecr_repo"
}

variable "aws_environement" {
  type    = string
  default = "devopsdemo"
}

variable "aws_vpc_name" {
  type    = string
  default = "vpc"
}
variable "aws_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}