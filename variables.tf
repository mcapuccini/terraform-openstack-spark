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

variable coreos_image_name {
  description = "Name of a CoreOS Container-Linux image in your project (to boot the nodes from)"
}

variable master_flavor_name {
  description = "Flavor name to be used for the master node"
}

variable spark_docker_image {
  description = "Spark Docker image"
  default     = "mcapuccini/spark-tensorflow:spk-2.1.3-tf-1.10.0-gpu-py3-zpl-0.7.3-hdp-2.7.6"
}

variable spark-ui-proxy_repo {
  description = "spark-ui-proxy Git repository"
  default     = "https://github.com/aseigneurin/spark-ui-proxy.git"
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

variable zeppelin_docker_image {
  description = "Apache Zeppelin Docker image"
  default     = "mcapuccini/spark-tensorflow:spk-2.1.3-tf-1.10.0-gpu-py3-zpl-0.7.3-hdp-2.7.6"
}

variable nvidia_driver_version {
  description = "NVIDIA driver version"
  default     = "396.44"
}
