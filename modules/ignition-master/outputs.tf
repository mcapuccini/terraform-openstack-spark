output "user_data" {
  description = "Rendered ignition configuration to provide as user_data"
  value       = "${data.ignition_config.bootstrap_config.rendered}"
}
