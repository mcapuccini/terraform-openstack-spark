output "master_public_ip" {
  description = "Public IP address of the master node"
  value       = "${element(module.master.public_ip_list,0)}"
}
