resource "template_file" "user_data" {
  template = "setup.tpl"

  vars {
    jnlp_port = "${var.jnlp_port}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
