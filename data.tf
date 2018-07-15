data "http" "ip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_ami" "jenkins" {
  most_recent = true

  # If we change the AWS Account in which test are run, update this value.
  owners = ["${var.aws_account}"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "is-public"
    values = ["false"]   // flip to public when ready for release
  }

  filter {
    name   = "name"
    values = ["jenkins-amazon-linux-*"]
  }
}
