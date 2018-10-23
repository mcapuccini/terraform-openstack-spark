output "id" {
  description = "Ignition hdfs-site.xml file id"
  value       = "${data.ignition_file.hdfs_site_xml.id}"
}
