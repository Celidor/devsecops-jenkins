resource "template_file" "user_data" {
  template = "${file("${path.module}/setup.tpl")}"

  vars {
    jnlp_port = "${var.jnlp_port}"
    plugins   = "${join(" ", var.plugins)}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
