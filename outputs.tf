output "jenkins_url" {
  value = "https://jenkins-${terraform.workspace}.${var.dns_zone}"
}
