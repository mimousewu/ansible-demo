#--------------------------------------------------------------
# General
#--------------------------------------------------------------
namespace = "costa"
profile = "costa"
name = "book-gw"

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------
region            = "cn-north-1"
azs             = ["cn-north-1a","cn-north-1b"]
vpc_cidr        = "172.31.0.0/16"
vpc_id             = "vpc-6b836f0e"
igw_id             = "igw-ebdc3c8e"
cidr_block         = "172.31.32.0/20"

#--------------------------------------------------------------
# Instance
#--------------------------------------------------------------
ami_id = "ami-d58658b8"
instance_type = "t2.large"
key_name = "gocd"