data "template_file" "spark-worker" {
  template = "${file("${path.module}/spark-worker.service")}"

  vars {
    spark_docker_image = "${var.spark_docker_image}"
    master_hostname    = "${var.master_hostname}"
  }
}

data "ignition_systemd_unit" "spark-worker" {
  name    = "spark-worker.service"
  enabled = true
  content = "${data.template_file.spark-worker.rendered}"
}
