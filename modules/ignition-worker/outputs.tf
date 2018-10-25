output "user_data_list" {
  description = "Rendered ignition configurations to provide as user_data"
  value       = ["${data.ignition_config.bootstrap_config.*.rendered}"]
}
