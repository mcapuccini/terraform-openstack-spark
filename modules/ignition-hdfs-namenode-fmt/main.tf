data "template_file" "hdfs-namenode-fmt" {
  template = "${file("${path.module}/hdfs-namenode-fmt.service")}"

  vars {
    hdfs_docker_image = "${var.hdfs_docker_image}"
  }
}

data "ignition_systemd_unit" "hdfs-namenode-fmt" {
  name    = "hdfs-namenode-fmt.service"
  enabled = false
  content = "${data.template_file.hdfs-namenode-fmt.rendered}"
}
