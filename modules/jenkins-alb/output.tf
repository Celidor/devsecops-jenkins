output "lb_dns_name" {
  value = "${aws_lb.alb.dns_name}"
}

output "alb_security_group_id" {
  value = "${module.lb-security-group.lb_security_group_id}"
}
