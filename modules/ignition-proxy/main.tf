data "template_file" "spark-ui-proxy" {
  template = "${file("${path.module}/spark-ui-proxy.service")}"

  vars {
    spark-ui-proxy_repo = "${var.spark-ui-proxy_repo}"
  }
}

data "ignition_systemd_unit" "spark-ui-proxy" {
  name    = "spark-ui-proxy.service"
  enabled = false
  content = "${data.template_file.spark-ui-proxy.rendered}"
}
