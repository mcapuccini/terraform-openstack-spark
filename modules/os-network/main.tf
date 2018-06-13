resource "openstack_networking_network_v2" "created" {
  # create only if var.existing_network_name is empty
  count          = "${var.existing_network_name == "" ? 1 : 0}"
  name           = "${var.name_prefix}-network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "created" {
  # create only if var.existing_network_name is empty
  count           = "${var.existing_network_name == "" ? 1 : 0}"
  name            = "${var.name_prefix}-subnet"
  network_id      = "${openstack_networking_network_v2.created.id}"
  cidr            = "${var.subnet_cidr}"
  ip_version      = 4
  dns_nameservers = ["${compact(split(",", var.dns_nameservers))}"]
  enable_dhcp     = true
}

resource "openstack_networking_router_v2" "created" {
  # create only if var.existing_network_name is empty
  count            = "${var.existing_network_name == "" ? 1 : 0}"
  name             = "${var.name_prefix}-router"
  external_gateway = "${var.external_net_uuid}"
}

resource "openstack_networking_router_interface_v2" "created" {
  # create only if var.existing_network_name is empty
  count     = "${var.existing_network_name == "" ? 1 : 0}"
  router_id = "${openstack_networking_router_v2.created.id}"
  subnet_id = "${openstack_networking_subnet_v2.created.id}"
}
