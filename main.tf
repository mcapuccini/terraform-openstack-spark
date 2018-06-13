module "keypair" {
  source      = "modules/os-keypair"
  name_prefix = "${var.cluster_prefix}"
  public_key  = "${var.public_key}"
}

module "network" {
  source            = "modules/os-network"
  name_prefix       = "${var.cluster_prefix}"
  external_net_uuid = "${var.external_net_uuid}"
}

module "secgroup" {
  source      = "modules/os-secgroup"
  name_prefix = "${var.cluster_prefix}"
}

data "template_file" "master_bootstrap" {
  template = "${file("${path.module}/bin/bootstrap-master.sh")}"

  vars {
    spark_docker_image = "${var.spark_docker_image}"
  }
}

module "master" {
  source             = "modules/os-node"
  name_prefix        = "${var.cluster_prefix}-master"
  count              = "1"
  flavor_name        = "${var.master_flavor_name}"
  image_name         = "${var.image_name}"
  keypair_name       = "${module.keypair.keypair_name}"
  network_name       = "${module.network.network_name}"
  secgroup_name      = "${module.secgroup.secgroup_name}"
  assign_floating_ip = "true"
  floating_ip_pool   = "${var.floating_ip_pool}"
  bootstrap_script   = "${data.template_file.master_bootstrap.rendered}"
}

data "template_file" "worker_bootstrap" {
  template = "${file("${path.module}/bin/bootstrap-worker.sh")}"

  vars {
    spark_docker_image = "${var.spark_docker_image}"
    master_private_ip  = "${element(module.master.local_ip_list,0)}"
  }
}

module "workers" {
  source             = "modules/os-node"
  name_prefix        = "${var.cluster_prefix}-worker"
  count              = "${var.workers_count}"
  flavor_name        = "${var.worker_flavor_name}"
  image_name         = "${var.image_name}"
  keypair_name       = "${module.keypair.keypair_name}"
  network_name       = "${module.network.network_name}"
  secgroup_name      = "${module.secgroup.secgroup_name}"
  assign_floating_ip = "${var.workers_floating_ip}"
  floating_ip_pool   = "${var.floating_ip_pool}"
  bootstrap_script   = "${data.template_file.worker_bootstrap.rendered}"
}
