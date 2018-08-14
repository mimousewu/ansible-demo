variable "namespace" {}
variable "profile" {}
variable "name" {}
variable "region" {}

variable "azs" {
  type = "list"
}

variable "vpc_cidr" {}
variable "vpc_id" {}
variable "igw_id" {}
variable "cidr_block" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${var.profile}"
}

module "subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  namespace          = "${var.namespace}"
  stage              = "prod"
  name               = "${var.name}"
  region             = "${var.region}"
  vpc_id             = "${var.vpc_id}"
  igw_id             = "${var.igw_id}"
  cidr_block         = "${var.cidr_block}"
  availability_zones = "${var.azs}"
}

// Set up a security group to the bastion
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

// Add our instance description
resource "aws_instance" "bastion" {
  ami               = "${var.ami_id}"
  source_dest_check = false
  instance_type     = "${var.instance_type}"
  subnet_id         = "${var.subnet_id}"
  key_name          = "${var.key_name}"
  security_groups   = ["${aws_security_group.bastion.id}"]

  tags {
    Name        = "bastion-01"
    Environment = "${var.environment}"
  }
}

resource "aws_instance" "bastion" {
  ami                         = "${var.ami.ami_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(split(",", var.public_subnet_ids), count.index)}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]
  associate_public_ip_address = true

  tags {
    Name = "${var.name}-01"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Setup our elastic ip
resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc      = true
}
