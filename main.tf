provider "aws" {
  region = "${var.aws_region}"
}

# Jenkins Master Instance
module "jenkins-master" {
  source = "./modules/jenkins-master"

  vpc_id     = "${module.jenkins-vpc.jenkins_vpc_id}"
  subnet_id  = "${module.jenkins-vpc.jenkins_subnet_az1_id}"
  subnet_ids = ["${module.jenkins-vpc.jenkins_subnet_az1_id}", "${module.jenkins-vpc.jenkins_subnet_az2_id}"]

  name          = "jenkins-${terraform.workspace}"
  alb_prefix    = "jenkins-${terraform.workspace}"
  instance_type = "${var.instance_type_master}"

  ami_id     = "${var.master_ami_id == "" ? data.aws_ami.jenkins.image_id : var.master_ami_id}"
  user_data  = ""
  setup_data = "${data.template_file.setup_data_master.rendered}"

  http_port                   = "${var.http_port}"
  allowed_ssh_cidr_blocks     = "${var.allowed_ssh_cidr_blocks}"     #["${chomp(data.http.ip.body)}/32"]   #["0.0.0.0/0"]
  allowed_inbound_cidr_blocks = "${var.allowed_inbound_cidr_blocks}" #["${chomp(data.http.ip.body)}/32"] #["0.0.0.0/0"]
  ssh_key_name                = "${var.ssh_key_name}"
  ssh_key_path                = "${var.ssh_key_path}"

  # Config used by the Application Load Balancer
  subnet_ids              = ["${module.jenkins-vpc.jenkins_subnet_az1_id}", "${module.jenkins-vpc.jenkins_subnet_az2_id}"]
  aws_ssl_certificate_arn = "${var.aws_ssl_certificate_arn}"
  dns_zone                = "${var.dns_zone}"
  app_dns_name            = "jenkins-${terraform.workspace}.${var.dns_zone}"
}

data "template_file" "setup_data_master" {
  template = "${file("./modules/jenkins-master/setup.tpl")}"

  vars = {
    jnlp_port = "${var.jnlp_port}"
    plugins   = "${join(" ", var.plugins)}"
  }
}

# Jenkins Linux Slave Instance(s)
/*
module "jenkins-linux-slave" {
  source = "./modules/jenkins-slave"

  count = "${var.linux_slave_count}"

  name          = "${var.name == "" ? "jenkins-linux-slave" : join("-", list(var.name, "jenkins-linux-slave"))}"
  instance_type = "${var.instance_type_slave}"

  ami_id                    = "${var.linux_slave_ami_id}"
  jenkins_security_group_id = "${module.jenkins-master.jenkins_security_group_id}"

  jenkins_master_ip   = "${module.jenkins-master.private_ip}"
  jenkins_master_port = "${var.http_port}"

  ssh_key_name = "${var.ssh_key_name}"
  ssh_key_path = "${var.ssh_key_path}"
}
*/
#data "aws_vpc" "default" {
#  default = true
#}

#data "aws_subnet_ids" "default" {
#  vpc_id = "${data.aws_vpc.default.id}"
#}

module "jenkins-vpc" {
  source = "./modules/jenkins-vpc"

  aws_region = "${var.aws_region}"
}
