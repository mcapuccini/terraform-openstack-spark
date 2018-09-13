#!/bin/bash

# Detect IP addresses
private_IPv4="$(ifconfig eth0 | awk '/inet / {print $2}')"
echo "Detected private IPv4: $private_IPv4"

# Start Spark worker
# shellcheck disable=SC2154,SC2016
docker run --detach \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --env "SPARK_MASTER_HOST=$private_IPv4" \
  --network host \
  --add-host "$(hostname):127.0.0.1" \
  --restart always \
  --name "spark-worker" \
  "${spark_docker_image}" \
  sh -c \
  '$SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker "spark://${master_private_ip}:7077"'
