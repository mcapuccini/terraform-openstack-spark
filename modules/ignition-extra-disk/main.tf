data "ignition_filesystem" "extra-disk" {
  name = "extra-disk"

  mount {
    device = "${var.device}"
    format = "ext4"
  }
}

data "template_file" "extra-disk" {
  template = "${file("${path.module}/media-disk.mount")}"

  vars {
    device = "${var.device}"
  }
}

data "ignition_systemd_unit" "extra-disk" {
  name    = "media-disk.mount"
  enabled = true
  content = "${data.template_file.extra-disk.rendered}"
}
