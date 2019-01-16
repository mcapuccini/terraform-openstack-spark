variable count {
  description = "Number of ignition configurations to create"
}

variable hostname {
  description = "Hostname to inject via Ignition (numerical postfix will be appended)"
}

variable nvidia_driver_version {
  description = "NVIDIA driver version"
}

variable spark_docker_image {
  description = "Spark Docker image"
}

variable hdfs_docker_image {
  description = "HDFS Docker image"
}

variable master_hostname {
  description = "Master hostname address"
}

variable public_key {
  description = "Local path to a SSH public key"
}

variable "core_site_xml" {
  description = "Hadoop core-site.xml"
}

variable "hdfs_site_xml" {
  description = "Hadoop hdfs-site.xml"
}

variable extra-disk_device {
  description = "Extra disk device path"
}
