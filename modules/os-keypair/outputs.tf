output "keypair_name" {
  description = "Name of the created keypair"
  value       = "${openstack_compute_keypair_v2.created.name}"
}
