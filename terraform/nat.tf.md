##
# This is for hacking into subnets module. because of there is no enough eip for each private subnets
# this file can be removed while comment the nat_gateway_enabled in main.ft

locals {
  stage     = "prod"
  delimiter = "-"

  eip_tags = {
    Namespace = "${var.namespace}"
    Stage     = "prod"
    Name      = "${var.namespace}-prod-${var.name}-private"
  }

  nat_tags = {
    Namespace = "${var.namespace}"
    Stage     = "prod"
    Name      = "${var.namespace}-prod-${var.name}"
  }
}

module "nat_label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace = "${var.namespace}"
  stage     = "${local.stage}"
  name      = "${var.name}"
  delimiter = "${local.delimiter}"
  tags      = "${local.nat_tags}"
}

resource "aws_eip" "default" {
  vpc  = true
  tags = "${local.eip_tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {
  allocation_id = "${aws_eip.default.id}"
  subnet_id     = "${element(module.subnets.private_subnet_ids, 0)}"
  tags          = "${module.nat_label.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

# data "aws_subnet_ids" "private" {
#   vpc_id = "${var.vpc_id}"
#
#   tags {
#     Name = "${var.namespace}-${local.stage}-subnet-private-${var.region}*"
#   }
# }


# data "aws_route_tables" "private" {
#   vpc_id = "${var.vpc_id}"
# 
#   tags {
#     Name = "${var.namespace}-${local.stage}-${var.name}-private"
#   }
# }
# 
# resource "aws_route" "default" {
#   count                  = "${length(data.aws_subnet_ids.private.ids)}"
#   route_table_id         = "${element(data.aws_route_tables.private.ids, count.index)}"
#   nat_gateway_id         = "${aws_nat_gateway.default.id}"
#   destination_cidr_block = "0.0.0.0/0"
# }

