output "id" {
  description = "Ignition zeppelin-site.xml file id"
  value       = "${data.ignition_file.zeppelin_site_xml.id}"
}
