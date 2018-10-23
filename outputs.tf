output "master_public_ip" {
  description = "Public IP address of the master node"
  value       = "${element(module.master.public_ip_list,0)}"
}

output "ssh_master_remove" {
  description = "Remove master IP from known_hosts"
  value       = "ssh-keygen -R ${element(module.master.public_ip_list,0)}"
}

output "master_login" {
  description = "Master login command"
  value       = "ssh core@${element(module.master.public_ip_list,0)}"
}

output "ssh_tunnel_zeppelin" {
  description = "Apache Zeppelin tunnelling command"
  value       = "ssh -N -f -L 8888:localhost:8888 core@${element(module.master.public_ip_list,0)}"
}

output "ssh_tunnel_sparkui" {
  description = "Spark UI tunnelling command"
  value       = "ssh -N -f -L 9999:localhost:9999 core@${element(module.master.public_ip_list,0)}"
}

output "ssh_tunnel_hdfs" {
  description = "HDFS NameNode UI tunnelling command"
  value       = "ssh -N -f -L 50070:localhost:50070 core@${element(module.master.public_ip_list,0)}"
}
