data "ignition_file" "zeppelin_site_xml" {
  filesystem = "root"
  path       = "/etc/zeppelin/zeppelin-site.xml"
  mode       = 644

  content {
    content = "${var.zeppelin_site_xml}"
  }
}
