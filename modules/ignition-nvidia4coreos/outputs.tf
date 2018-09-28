output "id" {
  description = "Ignition systemd unit id"
  value       = "${data.ignition_systemd_unit.nvidia4coreos.id}"
}
