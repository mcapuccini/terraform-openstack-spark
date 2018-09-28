data "ignition_file" "update_conf" {
  filesystem = "root"
  path       = "/etc/coreos/update.conf"
  mode       = 420

  content {
    content = "${file("${path.module}/update.conf")}"
  }
}
