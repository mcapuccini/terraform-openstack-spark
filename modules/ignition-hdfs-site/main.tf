data "ignition_file" "hdfs_site_xml" {
  filesystem = "root"
  path       = "/etc/hadoop/hdfs-site.xml"
  mode       = 644

  content {
    content = "${var.hdfs_site_xml}"
  }
}
