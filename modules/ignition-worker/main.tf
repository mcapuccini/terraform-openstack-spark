# User
module "user" {
  source     = "../ignition-user"
  public_key = "${var.public_key}"
}

# Files
module "hostname" {
  source   = "../ignition-hostname"
  count    = "${var.count}"
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

# Services
module "nvidia4coreos" {
  source                = "../ignition-nvidia4coreos"
  nvidia_driver_version = "${var.nvidia_driver_version}"
}

module "spark-worker" {
  source             = "../ignition-spark-worker"
  spark_docker_image = "${var.spark_docker_image}"
  master_hostname    = "${var.master_hostname}"
}

module "hdfs-datanode" {
  source                 = "../ignition-hdfs-datanode"
  hdfs_docker_image      = "${var.hdfs_docker_image}"
  hdfs_namenode_hostname = "${var.master_hostname}"
}

# Extra disk
module "extra-disk" {
  source = "../ignition-extra-disk"
  device = "${var.extra-disk_device}"
}

# Config
data "ignition_config" "bootstrap_config" {
  count = "${var.count}"

  users = [
    "${module.user.id}",
  ]

  files = [
    "${element(module.hostname.id,count.index)}",
    "${module.updates.id}",
    "${module.core_site_xml.id}",
    "${module.hdfs_site_xml.id}",
  ]

  systemd = [
    "${module.nvidia4coreos.id}",
    "${module.spark-worker.id}",
    "${module.hdfs-datanode.id}",
    "${module.extra-disk.systemd_unit_id}",
  ]

  filesystems = [
    "${module.extra-disk.filesystem_id}",
  ]
}
