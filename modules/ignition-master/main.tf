# User
module "user" {
  source     = "../ignition-user"
  public_key = "${var.public_key}"
}

# Files
module "hostname" {
  source   = "../ignition-hostname"
  count    = "1"
  hostname = "${var.hostname}"
}

module "updates" {
  source = "../ignition-updates"
}

module "core_site_xml" {
  source        = "../ignition-core-site"
  core_site_xml = "${var.core_site_xml}"
}

module "hdfs_site_xml" {
  source        = "../ignition-hdfs-site"
  hdfs_site_xml = "${var.hdfs_site_xml}"
}

module "zeppelin_site_xml" {
  source            = "../ignition-zeppelin-site"
  zeppelin_site_xml = "${var.zeppelin_site_xml}"
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

module "hdfs-namenode-fmt" {
  source            = "../ignition-hdfs-namenode-fmt"
  hdfs_docker_image = "${var.hdfs_docker_image}"
}

module "hdfs-namenode" {
  source            = "../ignition-hdfs-namenode"
  hdfs_docker_image = "${var.hdfs_docker_image}"
}

# Config
data "ignition_config" "bootstrap_config" {
  users = [
    "${module.user.id}",
  ]

  files = [
    "${element(module.hostname.id,0)}",
    "${module.updates.id}",
    "${module.core_site_xml.id}",
    "${module.hdfs_site_xml.id}",
    "${module.zeppelin_site_xml.id}",
  ]

  systemd = [
    "${module.nvidia4coreos.id}",
    "${module.spark-master.id}",
    "${module.spark-ui-proxy.id}",
    "${module.zeppelin.id}",
    "${module.hdfs-namenode.id}",
    "${module.hdfs-namenode-fmt.id}",
  ]
}
