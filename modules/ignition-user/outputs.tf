output "id" {
  description = "Ignition user id"
  value       = "${data.ignition_user.user.id}"
}
