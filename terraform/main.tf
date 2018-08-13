variable "namespace" {}
variable "profile" {}
variable "name" {}
variable "region" {}
variable "azs" {}
variable "vpc_cidr" {}
variable "vpc_id" {}
variable "igw_id" {}
variable "cidr_block" {}

provider "aws" {
  region                  = "cn-north-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "costa"
}

module "subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  namespace          = "costa"
  stage              = "prod"
  name               = "book-gw"
  region             = "cn-north-1"
  vpc_id             = "vpc-6b836f0e"
  igw_id             = "igw-ebdc3c8e"
  cidr_block         = "172.31.32.0/20"
  availability_zones = ["cn-north-1a", "cn-north-1b"]
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allows ssh from the world"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "bastion"
  }
}
