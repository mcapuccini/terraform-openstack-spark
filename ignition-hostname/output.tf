output "id" {
  description = "Ignition hostname id list"
  value       = ["${data.ignition_file.hostname.*.id}"]
}
