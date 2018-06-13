variable cluster_prefix {
  description = "Prefix for the cluster resources name"
  default     = "spark"
}

variable public_key {
  description = "Local path to a SSH public key"
}

variable external_net_uuid {
  description = "External network UUID"
}

variable floating_ip_pool {
  description = "Name of the floating IP pool (often same as the external network name)"
}

variable image_name {
  description = "Image name to boot the nodes from"
}

variable master_flavor_name {
  description = "Flavor name to be used for the master node"
}

variable spark_docker_image {
  description = "Spark Docker image"
  default     = "gettyimages/spark:2.2.1-hadoop-2.7"
}

variable worker_flavor_name {
  description = "Flavor name to be used for the worker nodes"
}

variable workers_count {
  description = "Number of workers to deploy"
}

variable workers_floating_ip {
  description = "If true a floating IP will be attached to each worker"
  default     = false
}
