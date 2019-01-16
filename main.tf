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

  provisioner "remote-exec" {
    inline = [
      "echo '${join("\n",concat(module.master.etc_hosts_entries,module.workers.etc_hosts_entries))}' | sudo tee -a /etc/hosts",
      "sudo systemctl enable nvidia4coreos && sudo systemctl start nvidia4coreos",
      "sudo systemctl enable hdfs-namenode-fmt && sudo systemctl start hdfs-namenode-fmt",
      "sudo systemctl enable hdfs-namenode && sudo systemctl start hdfs-namenode",
      "sudo systemctl enable spark-master && sudo systemctl start spark-master",
      "sudo systemctl enable spark-ui-proxy && sudo systemctl start spark-ui-proxy",
      "sudo systemctl enable zeppelin && sudo systemctl start zeppelin",
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

  provisioner "remote-exec" {
    inline = [
      "echo '${join("\n",concat(module.master.etc_hosts_entries,module.workers.etc_hosts_entries))}' | sudo tee -a /etc/hosts",
      "sudo systemctl enable nvidia4coreos && sudo systemctl start nvidia4coreos",
      "sudo systemctl enable hdfs-datanode && sudo systemctl start hdfs-datanode",
      "sudo systemctl enable spark-worker && sudo systemctl start spark-worker",
    ]
  }
}
