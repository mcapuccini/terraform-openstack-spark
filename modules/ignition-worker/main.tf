# User
module "user" {
  source     = "../ignition-user"
  public_key = "${var.public_key}"
}

# Files
module "updates" {
  source = "../ignition-updates"
}

# Services
module "nvidia4coreos" {
  source                = "../ignition-nvidia4coreos"
  nvidia_driver_version = "${var.nvidia_driver_version}"
}

module "spark-worker" {
  source             = "../ignition-spark-worker"
  spark_docker_image = "${var.spark_docker_image}"
  master_private_ip  = "${var.master_private_ip}"
}

# Config
data "ignition_config" "bootstrap_config" {
  users = [
    "${module.user.id}",
  ]

  files = [
    "${module.updates.id}",
  ]

  systemd = [
    "${module.nvidia4coreos.id}",
    "${module.spark-worker.id}",
  ]
}
