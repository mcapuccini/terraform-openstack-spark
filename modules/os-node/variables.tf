variable count {
  description = "Number of nodes to be created"
}

variable name_prefix {
  description = "Prefix for the node name"
}

variable flavor_name {
  description = "Flavor name to be used for this node"
}

variable flavor_id {
  description = "Flavor ID to be used for this node (optional, set it in alternative to flavor_name)"
  default     = ""
}

variable image_name {
  description = "Image name to boot this node from"
}

variable network_name {
  description = "Name of the network to attach this node to"
}

variable secgroup_name {
  description = "Name of the security group to apply to this node"
}

variable assign_floating_ip {
  description = "If true a floating IP will be attached to this node"
  default     = false
}

variable floating_ip_pool {
  description = "Name of the floating IP pool (optional if assign_floating_ip is false)"
  default     = ""
}

variable extra_disk_size {
  description = "If greater than 0 a block storage volume will be attached to this node"
  default     = 0
}

variable bootstrap_script {
  description = "Script to be executed at boot time (cloud-init user-data)"
}
