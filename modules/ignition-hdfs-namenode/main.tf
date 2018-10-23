data "template_file" "hdfs-namenode" {
  template = "${file("${path.module}/hdfs-namenode.service")}"

  vars {
    hdfs_docker_image = "${var.hdfs_docker_image}"
  }
}

data "ignition_systemd_unit" "hdfs-namenode" {
  name    = "hdfs-namenode.service"
  enabled = true
  content = "${data.template_file.hdfs-namenode.rendered}"
}
