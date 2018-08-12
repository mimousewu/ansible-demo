FROM centos:7.4.1708

RUN yum install epel-release  -y \
	&& yum install ansible -y