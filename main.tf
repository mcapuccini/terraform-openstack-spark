module "network" {
  source            = "modules/os-network"
  name_prefix       = "${var.cluster_prefix}"
  external_net_uuid = "${var.external_net_uuid}"
}

module "secgroup" {
  source      = "modules/os-secgroup"
  name_prefix = "${var.cluster_prefix}"
}

module "master_ignition" {
  source                = "modules/ignition-master"
  hostname              = "${var.cluster_prefix}-master"
  spark_docker_image    = "${var.spark_docker_image}"
  hdfs_docker_image     = "${var.hdfs_docker_image}"
  spark-ui-proxy_repo   = "${var.spark-ui-proxy_repo}"
  zeppelin_docker_image = "${var.zeppelin_docker_image}"
  nvidia_driver_version = "${var.nvidia_driver_version}"
  public_key            = "${var.public_key}"
  core_site_xml         = "${var.core_site_xml}"
  hdfs_site_xml         = "${var.hdfs_site_xml}"
  zeppelin_site_xml     = "${var.zeppelin_site_xml}"
}

module "master" {
  source             = "modules/os-node"
  name_prefix        = "${var.cluster_prefix}-master"
  count              = "1"
  flavor_name        = "${var.master_flavor_name}"
  image_name         = "${var.coreos_image_name}"
  network_name       = "${module.network.network_name}"
  secgroup_name      = "${module.secgroup.secgroup_name}"
  assign_floating_ip = "true"
  floating_ip_pool   = "${var.floating_ip_pool}"
  user_data_list     = ["${module.master_ignition.user_data}"]
}

module "worker_ignition" {
  source                = "modules/ignition-worker"
  count                 = "${var.workers_count}"
  hostname              = "${var.cluster_prefix}-worker"
  spark_docker_image    = "${var.spark_docker_image}"
  hdfs_docker_image     = "${var.hdfs_docker_image}"
  master_private_ip     = "${element(module.master.local_ip_list,0)}"
  master_hostname       = "${element(module.master.hostnames,0)}"
  nvidia_driver_version = "${var.nvidia_driver_version}"
  public_key            = "${var.public_key}"
  core_site_xml         = "${var.core_site_xml}"
  hdfs_site_xml         = "${var.hdfs_site_xml}"
  extra-disk_device     = "${var.worker_volume_device}"
}

module "workers" {
  source             = "modules/os-node"
  name_prefix        = "${var.cluster_prefix}-worker"
  count              = "${var.workers_count}"
  flavor_name        = "${var.worker_flavor_name}"
  image_name         = "${var.coreos_image_name}"
  network_name       = "${module.network.network_name}"
  secgroup_name      = "${module.secgroup.secgroup_name}"
  assign_floating_ip = "${var.workers_floating_ip}"
  floating_ip_pool   = "${var.floating_ip_pool}"
  user_data_list     = "${module.worker_ignition.user_data_list}"
  extra_disk_size    = "${var.worker_volume_size}"
}

# SSH provisioners
# Master
resource "null_resource" "ssh-master" {
  triggers {
    cluster_instance_ids = "${join(",", module.master.node_id_list)}"
  }

  connection {
    host        = "${element(module.master.public_ip_list,0)}"
    user        = "core"
    private_key = "${file(replace(var.public_key,".pub",""))}"
  }

  # Populate /etc/hosts and wait for master to be ready
  provisioner "remote-exec" {
    inline = [
      "echo '${join("\n",concat(module.master.etc_hosts_entries,module.workers.etc_hosts_entries))}' | sudo tee -a /etc/hosts",
      "while ! (systemctl is-failed -q docker || systemctl is-active -q docker); do sleep 2; done",
      "if systemctl is-failed -q docker; then exit 1; fi",
      "while ! (systemctl is-failed -q nvidia4coreos || docker ps -a | grep -q nvidia4coreos); do sleep 2; done",
      "if systemctl is-failed -q nvidia4coreos; then exit 1; fi",
      "while ! (systemctl is-failed -q spark-ui-proxy || docker ps -a | grep -q spark-ui-proxy); do sleep 2; done",
      "if systemctl is-failed -q spark-ui-proxy; then exit 1; fi",
      "while ! (systemctl is-failed -q spark-master || docker ps -a | grep -q spark-master); do sleep 2; done",
      "if systemctl is-failed -q spark-master; then exit 1; fi",
      "while ! (systemctl is-failed -q zeppelin || docker ps -a | grep -q zeppelin); do sleep 2; done",
      "if systemctl is-failed -q zeppelin; then exit 1; fi",
      "while ! (systemctl is-failed -q hdfs-namenode || docker ps -a | grep -q hdfs-namenode); do sleep 2; done",
      "if systemctl is-failed -q hdfs-namenode; then exit 1; fi",
    ]
  }
}

# Workers
resource "null_resource" "ssh-workers" {
  count = "${var.workers_count}"

  triggers {
    cluster_instance_ids = "${join(",", concat(module.master.node_id_list, module.workers.node_id_list))}"
  }

  connection {
    host             = "${element(module.workers.local_ip_list,count.index)}"
    user             = "core"
    bastion_host_key = "${file(replace(var.public_key,".pub",""))}"
    bastion_host     = "${element(module.master.public_ip_list,0)}"
  }

  # Populate /etc/hosts
  provisioner "remote-exec" {
    inline = [
      "echo '${join("\n",concat(module.master.etc_hosts_entries,module.workers.etc_hosts_entries))}' | sudo tee -a /etc/hosts",
    ]
  }
}
