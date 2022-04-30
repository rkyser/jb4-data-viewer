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
    admin_username = "admin"
    admin_password = "password"
}

module "docker_influxdb2" {
    source = "./modules/docker_influxdb2"
    docker_net_name = "${docker_network.private_network.name}"
    docker_volume_name = "jb4-influxdb2-volume"
    docker_container_name = "jb4-influxdb2"
    admin_username = "admin"
    admin_password = "password"
    admin_token = "${random_password.influxdb_admin_token.result}"
}

# https://registry.terraform.io/providers/grafana/grafana/latest/docs#auth
provider "grafana" {
  alias = "base"
  url   = "http://localhost:3001"
  auth  = "${var.admin_username}:${var.admin_password}"
}
