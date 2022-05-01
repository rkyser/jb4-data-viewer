terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.16.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.3"
    }
    grafana = {
      source = "grafana/grafana"
      version = "1.22.0"
    }
  }
}

resource "random_password" "influxdb_admin_token" {
  length = 64
  special = false
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "private_network" {
  name = "datanet"
  attachable = true
}

module "docker_grafana" {
    source = "./modules/docker_grafana"
    docker_net_name = "${docker_network.private_network.name}"
    docker_volume_name = "jb4-grafana-volume2"
    docker_container_name = "jb4-grafana"
    admin_username = var.grafana_admin_username
    admin_password = var.grafana_admin_password
}

module "docker_influxdb2" {
    source = "./modules/docker_influxdb2"
    docker_net_name = "${docker_network.private_network.name}"
    docker_volume_name = "jb4-influxdb2-volume"
    docker_container_name = "jb4-influxdb2"
    admin_username = var.influxdb2_admin_username
    admin_password = var.influxdb2_admin_password
    admin_token = "${random_password.influxdb_admin_token.result}"
}

# https://registry.terraform.io/providers/grafana/grafana/latest/docs#auth
provider "grafana" {
  url   = "http://localhost:3001"
  auth  = "${var.grafana_admin_username}:${var.grafana_admin_password}"
}

resource "grafana_data_source" "influxdb" {
  type          = "influxdb"
  name          = "JB4-Metrics"
  url           = "http://${module.docker_influxdb2.hostname}:8086/"
  json_data {
    version = "Flux"
    organization = "${module.docker_influxdb2.organization}"
    default_bucket = "${module.docker_influxdb2.bucket}"
  }
# For now the token has to be added manually. The provider doesn't
# seem to support adding a Flux auth token.
#   secure_json_data {
#     token = "${random_password.influxdb_admin_token.result}"
#   }
}
