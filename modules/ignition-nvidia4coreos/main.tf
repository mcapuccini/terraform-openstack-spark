data "template_file" "nvidia4coreos" {
  template = "${file("${path.module}/nvidia4coreos.service")}"

  vars {
    nvidia_driver_version = "${var.nvidia_driver_version}"
  }
}

data "ignition_systemd_unit" "nvidia4coreos" {
  name    = "nvidia4coreos.service"
  enabled = false
  content = "${data.template_file.nvidia4coreos.rendered}"
}
