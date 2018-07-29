output "jenkins_url" {
  value = "https://jenkins-${terraform.workspace}.${var.dns_zone}"
}

output "jenkins_server_public_ip" {
  value = "${module.jenkins-master.public_ip}"
}
