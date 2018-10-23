data "ignition_file" "hostname" {
  count      = "${var.count}"
  filesystem = "root"
  path       = "/etc/hostname"
  mode       = 420

  content {
    content = "${var.hostname}-${format("%03d", count.index)}"
  }
}
