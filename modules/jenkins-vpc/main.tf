resource "aws_vpc" "jenkins" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "jenkins-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_subnet" "jenkins_az1" {
  vpc_id                  = "${aws_vpc.jenkins.id}"
  cidr_block              = "${var.frontend_cidr_az1}"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags {
    Name        = "jenkins-az1-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_subnet" "jenkins_az2" {
  vpc_id                  = "${aws_vpc.jenkins.id}"
  cidr_block              = "${var.frontend_cidr_az2}"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags {
    Name        = "jenkins-az2-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "jenkins" {
  vpc_id = "${aws_vpc.jenkins.id}"

  tags {
    Name        = "jenkins-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_route_table" "jenkins" {
  vpc_id = "${aws_vpc.jenkins.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.jenkins.id}"
  }

  tags {
    Name        = "jenkins-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_route_table_association" "jenkins_az1" {
  subnet_id      = "${aws_subnet.jenkins_az1.id}"
  route_table_id = "${aws_route_table.jenkins.id}"
}

resource "aws_route_table_association" "jenkins_az2" {
  subnet_id      = "${aws_subnet.jenkins_az2.id}"
  route_table_id = "${aws_route_table.jenkins.id}"
}
