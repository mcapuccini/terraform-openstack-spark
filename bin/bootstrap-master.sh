#!/bin/bash

# Detect IP addresses
private_IPv4="$(ifconfig eth0 | awk '/inet / {print $2}')"
public_IPv4="$(curl -4 icanhazip.com)"
echo "Detected private IPv4: $private_IPv4"
echo "Detected public IPv4: $public_IPv4"

# Start Spark master
# shellcheck disable=SC2154
docker run --detach \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --env "SPARK_MASTER_HOST=$private_IPv4" \
  --network host \
  --add-host "$(hostname):127.0.0.1" \
  --restart always \
  --name "spark-master" \
  "${spark_docker_image}" \
  bin/spark-class org.apache.spark.deploy.master.Master

# Start spark-ui-proxy
# shellcheck disable=SC2154
docker run --detach \
  --network host \
  --restart always \
  --name "spark-ui-proxy" \
  "${spark-ui-proxy_docker_image}" \
  localhost:8080 9999
