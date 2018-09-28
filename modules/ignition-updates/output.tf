output "id" {
  description = "Ignition update.conf file id"
  value       = "${data.ignition_file.update_conf.id}"
}
