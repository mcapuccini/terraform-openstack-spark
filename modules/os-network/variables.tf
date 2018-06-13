variable name_prefix {
  description = "Prefix for the keypair name"
}

variable existing_network_name {
  description = "Name of an existing network (optional, if set no network will be created and this name will be outputted)"
  default     = ""
}

variable subnet_cidr {
  description = "Subnet CIDR"
  default     = "10.0.0.0/16"
}

variable external_net_uuid {
  description = "External network UUID"
}

variable dns_nameservers {
  description = "DNS nameservers"
  default     = "8.8.8.8,8.8.4.4"
}
