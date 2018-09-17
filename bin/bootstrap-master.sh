#!/bin/bash

# Prevent rebooting
echo "REBOOT_STRATEGY=off" | sudo tee --append /etc/coreos/update.conf
sudo systemctl restart locksmithd

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

# Start Spark master
# shellcheck disable=SC2154,SC2016
docker run --detach \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --env "SPARK_MASTER_HOST=$private_IPv4" \
  --network host \
  --add-host "$(hostname):127.0.0.1" \
  --restart always \
  --volumes-from nvidia4coreos \
  --name "spark-master" \
  "${spark_docker_image}" \
  sh -c 'export PATH=$PATH:/opt/nvidia/bin/;
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/nvidia/lib;
  $SPARK_HOME/bin/spark-class org.apache.spark.deploy.master.Master'

# Start spark-ui-proxy
# shellcheck disable=SC2154
docker build -t local/spark-ui-proxy "${spark-ui-proxy_repo}"
docker run --detach \
  --network host \
  --restart always \
  --name "spark-ui-proxy" \
  local/spark-ui-proxy \
  localhost:8080 9999

# Start Zeppelin
# shellcheck disable=SC2154,SC2016
docker run --detach \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume /var/zeppelin-notebooks:/notebooks \
  --net=host \
  --add-host "$(hostname):127.0.0.1" \
  --restart always \
  --env MASTER="spark://$private_IPv4:7077" \
  --env ZEPPELIN_PORT=8888 \
  --env ZEPPELIN_NOTEBOOK_DIR=/notebooks \
  --volumes-from nvidia4coreos \
  --name "zeppelin" \
  "${zeppelin_docker_image}" \
  sh -c 'export PATH=$PATH:/opt/nvidia/bin/;
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/nvidia/lib;
  $Z_HOME/bin/zeppelin.sh'

# Singnal done
touch /tmp/bootstrap-signal
