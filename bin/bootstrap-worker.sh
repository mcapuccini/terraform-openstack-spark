#!/bin/bash

# Detect IP addresses
private_IPv4="$(ifconfig eth0 | awk '/inet / {print $2}')"
echo "Detected private IPv4: $private_IPv4"

# Install GPU driver, if card is present
if lspci | grep -q NVIDIA; then
  # shellcheck disable=SC2154
  docker run --name nvidia4coreos --privileged --volume /:/hostfs "${nvidia4coreos_docker_image}"
  sudo systemctl enable /etc/systemd/system/nvidia4coreos.service
  sudo systemctl start nvidia4coreos.service
else
  # Run the container to create the volume
  # shellcheck disable=SC2154
  docker run --name nvidia4coreos "${nvidia4coreos_docker_image}" true
fi

# Start Spark worker
# shellcheck disable=SC2154,SC2016
docker run --detach \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --env "SPARK_MASTER_HOST=$private_IPv4" \
  --network host \
  --add-host "$(hostname):127.0.0.1" \
  --restart always \
  --volumes-from nvidia4coreos \
  --name "spark-worker" \
  "${spark_docker_image}" \
  sh -c 'export PATH=$PATH:/opt/nvidia/bin/;
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/nvidia/lib;
  $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker "spark://${master_private_ip}:7077"'
