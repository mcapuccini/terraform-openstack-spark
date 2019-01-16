data "template_file" "spark-master" {
  template = "${file("${path.module}/spark-master.service")}"

  vars {
    spark_docker_image = "${var.spark_docker_image}"
  }
}

data "ignition_systemd_unit" "spark-master" {
  name    = "spark-master.service"
  enabled = false
  content = "${data.template_file.spark-master.rendered}"
}
