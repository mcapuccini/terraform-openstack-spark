data "ignition_file" "core_site_xml" {
  filesystem = "root"
  path       = "/etc/hadoop/core-site.xml"
  mode       = 644

  content {
    content = "${var.core_site_xml}"
  }
}
