# OpenStack Apache Spark Terraform Module

[![Build Status](https://travis-ci.org/mcapuccini/terraform-openstack-spark.svg?branch=master)](https://travis-ci.org/mcapuccini/terraform-openstack-spark)

Terraform module to deploy [Apache Spark](https://spark.apache.org/) on [OpenStack](https://www.openstack.org/). By deploying this module you will get:

- A standalone [Apache Spark](https://spark.apache.org/) cluster up and running
- [Apache Zeppelin](https://zeppelin.apache.org/) for interactive analysis
- [Tensorflow](https://www.tensorflow.org/) dependencies on each node
- [NVIDIA](https://www.nvidia.com/) GPU drivers on each node

## Table of contents
- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Deploy](#deploy)
- [Scale](#scale)
- [Destroy](#destroy)

## Prerequisites
On your workstation you need to:

- Install [Terraform](https://www.terraform.io/)
- Set up the environmet by sourcing the OpenStack RC file for your project 

On your OpenStack project you need to:

- Import the [CoreOS](https://coreos.com/) Container-Linux image (instructions [here](https://coreos.com/os/docs/latest/booting-on-openstack.html))

## Configuration

Start by creating a directory, locating into it and by creating the main Terraform configuration file:

```
mkdir deployment
cd deployment
touch main.tf
```

In `main.tf` paste and fill in the following configuration:

```hcl
module "spark" {
  source  = "mcapuccini/spark/openstack"
  # Required variables
  public_key="" # Path to a public SSH key
  external_net_uuid="" # External network UUID
  floating_ip_pool="" # Floating IP pool name
  image_name="" # Name of a CoreOS Container-Linux image in your project
  master_flavor_name="" # Flavor name to be used for the master node
  worker_flavor_name="" # Flavor name to be user for the worker nodes
  workers_count=3 # Number of worker nodes to deploy
}
```

Init the Terraform directory by running:

```
terraform init
```

## Deploy

To deploy please run:

```
terraform apply
```

Once the deployment is done, to get the SSH tunnelling commands to the interfaces you can run:

```
terraform output -module=spark
```

## Scale

To scale the cluster you can increase and decrease the number of workers in `main.tf` and rerun `terraform apply`.

## Destroy

You can delete the cluster by running:

```
terraform destroy
```
