output "id" {
  description = "Ignition systemd unit id"
  value       = "${data.ignition_systemd_unit.spark-worker.id}"
}
