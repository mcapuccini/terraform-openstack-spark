output "id" {
  description = "Ignition systemd unit id"
  value       = "${data.ignition_systemd_unit.zeppelin.id}"
}
