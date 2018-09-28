data "template_file" "zeppelin" {
  template = "${file("${path.module}/zeppelin.service")}"

  vars {
    zeppelin_docker_image = "${var.zeppelin_docker_image}"
  }
}

data "ignition_systemd_unit" "zeppelin" {
  name    = "zeppelin.service"
  enabled = true
  content = "${data.template_file.zeppelin.rendered}"
}
