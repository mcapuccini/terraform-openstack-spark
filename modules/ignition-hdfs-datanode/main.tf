data "template_file" "hdfs-datanode" {
  template = "${file("${path.module}/hdfs-datanode.service")}"

  vars {
    hdfs_docker_image      = "${var.hdfs_docker_image}"
    hdfs_namenode_hostname = "${var.hdfs_namenode_hostname}"
    hdfs_namenode_address  = "${var.hdfs_namenode_address}"
  }
}

data "ignition_systemd_unit" "hdfs-datanode" {
  name    = "hdfs-datanode.service"
  enabled = true
  content = "${data.template_file.hdfs-datanode.rendered}"
}