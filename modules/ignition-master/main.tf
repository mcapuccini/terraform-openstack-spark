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

module "spark-master" {
  source             = "../ignition-spark-master"
  spark_docker_image = "${var.spark_docker_image}"
}

module "spark-ui-proxy" {
  source              = "../ignition-proxy"
  spark-ui-proxy_repo = "${var.spark-ui-proxy_repo}"
}

module "zeppelin" {
  source                = "../ignition-zeppelin"
  zeppelin_docker_image = "${var.zeppelin_docker_image}"
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
    "${module.spark-master.id}",
    "${module.spark-ui-proxy.id}",
    "${module.zeppelin.id}",
  ]
}
