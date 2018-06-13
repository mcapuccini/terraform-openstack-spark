resource "openstack_compute_secgroup_v2" "created" {
  # create only if var.existing_secgroup_name is empty
  count       = "${var.existing_secgroup_name == "" ? 1 : 0}"
  name        = "${var.name_prefix}-secgroup"
  description = "The automatically created secgroup for ${var.name_prefix}"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 1      # All internal tcp traffic
    to_port     = 65535
    ip_protocol = "tcp"
    self        = "true"
  }

  rule {
    from_port   = 1      # All internal udp traffic
    to_port     = 65535
    ip_protocol = "udp"
    self        = "true"
  }
}
