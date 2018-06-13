resource "openstack_compute_keypair_v2" "created" {
  name       = "${var.name_prefix}-keypair"
  public_key = "${file(var.public_key)}"
}
