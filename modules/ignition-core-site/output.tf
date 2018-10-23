output "id" {
  description = "Ignition core-site.xml file id"
  value       = "${data.ignition_file.core_site_xml.id}"
}
