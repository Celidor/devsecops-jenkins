output "jenkins_vpc_id" {
  value = "${aws_vpc.jenkins.id}"
}

output "jenkins_subnet_az1_id" {
  value = "${aws_subnet.jenkins_az1.id}"
}

output "jenkins_subnet_az2_id" {
  value = "${aws_subnet.jenkins_az2.id}"
}
