output "extra_disk_devices" {
  description = "List of attached block storage device paths (one per node)"
  value       = ["${openstack_compute_volume_attach_v2.attach_extra_disk.*.device}"]
}

output "local_ip_list" {
  description = "List of local IPv4 addresses (one per node)"
  value       = ["${openstack_compute_instance_v2.instance.*.network.0.fixed_ip_v4}"]
}

output "public_ip_list" {
  description = "List of floating IP addresses (one per node)"
  value       = ["${openstack_compute_floatingip_v2.floating_ip.*.address}"]
}

output "hostnames" {
  description = "List of hostnames (one per node)"
  value       = ["${openstack_compute_instance_v2.instance.*.name}"]
}

output "node_id_list" {
  description = "List of ids (one per node)"
  value       = ["${openstack_compute_instance_v2.instance.*.id}"]
}
