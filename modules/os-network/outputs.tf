output "network_name" {
  # The join() hack is required because currently the ternary operator
  # evaluates the expressions on both branches of the condition before
  # returning a value. When providing and external Network, the template Network
  # resource gets a count of zero which triggers an evaluation error.
  #
  # This is tracked upstream: https://github.com/hashicorp/hil/issues/50
  #
  description = "Name of the created network (or existing network if specified)"

  value = "${ var.existing_network_name == "" ? join(" ", openstack_networking_network_v2.created.*.name) : var.existing_network_name }"
}
