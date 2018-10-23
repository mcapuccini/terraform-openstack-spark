output "filesystem_id" {
  description = "Ingnition filesystem ID"
  value       = "${data.ignition_filesystem.extra-disk.id}"
}

output "systemd_unit_id" {
  description = "Ignition systemd unit ID"
  value       = "${data.ignition_systemd_unit.extra-disk.id}"
}
