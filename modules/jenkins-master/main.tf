# Jenkins Master Server
resource "aws_instance" "ec2_jenkins_master" {
  count                  = 1
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  user_data              = "${template_file.user_data.rendered}"
  key_name               = "${var.ssh_key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.jenkins_server.name}"
  subnet_id              = "${var.subnet_id}"
  monitoring             = true
  vpc_security_group_ids = ["${module.security_group_rules.jenkins_security_group_id}"]

  tags {
    Name        = "jenkins-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

# Jenkins server security group
module "security_group_rules" {
  source = "../jenkins-security-group-rules"

  name                        = "jenkins-${terraform.workspace}"
  allowed_inbound_cidr_blocks = ["${var.allowed_inbound_cidr_blocks}"]
  allowed_ssh_cidr_blocks     = ["${var.allowed_ssh_cidr_blocks}"]
  alb_security_group_id       = "${module.jenkins-alb.alb_security_group_id}"
  vpc_id                      = "${var.vpc_id}"

  http_port  = "${var.http_port}"
  https_port = "${var.https_port}"
  jnlp_port  = "${var.jnlp_port}"
}

# application load balancer
module "jenkins-alb" {
  source                      = "../jenkins-alb"
  name_prefix                 = "${var.alb_prefix}"
  vpc_id                      = "${var.vpc_id}"
  allowed_inbound_cidr_blocks = "${var.allowed_inbound_cidr_blocks}"
  http_port                   = "${var.http_port}"
  jenkins_instance_id         = "${aws_instance.ec2_jenkins_master.id}"
  subnet_ids                  = "${var.subnet_ids}"
  aws_ssl_certificate_arn     = "${var.aws_ssl_certificate_arn}"
  app_dns_name                = "${var.app_dns_name}"
  dns_zone                    = "${var.dns_zone}"
}
