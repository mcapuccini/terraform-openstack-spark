variable name_prefix {
  description = "Prefix for the security group name"
}

variable existing_secgroup_name {
  description = "Name of an existing security group (optional, if set no security group will be created and this name will be outputted)"
  default     = ""
}
