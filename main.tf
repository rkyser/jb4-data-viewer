terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
      version = "1.21.1"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "2.16.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.3"
    }
  }
}

resource "random_password" "influxdb_admin_token" {
  length = 64
  special = false
}

resource "random_password" "influxdb_admin_password" {
  length = 10
  special = false
}

resource "random_password" "grafana_admin_password" {
  length = 10
  special = false
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "grafana" {
  name = "grafana/grafana-oss:8.2.6"
}

resource "docker_image" "influxdb2" {
  name = "influxdb:2.2"
}

resource "docker_network" "private_network" {
  name = "datanet"
  attachable = true
}

## TODO: need to back containers with volumes

resource "docker_container" "jb4_grafana" {
  image = docker_image.grafana.latest
  name  = "jb4_grafana"
  networks_advanced {
    name = "${docker_network.private_network.name}"
  }
  ports {
      internal = 3000
      external = 3001
  }
  env = [
      "GF_SECURITY_ADMIN_USER=admin",
      "GF_SECURITY_ADMIN_PASSWORD=${random_password.grafana_admin_password.result}"
  ]
}

# https://hub.docker.com/_/influxdb
resource "docker_container" "jb4_influxdb2" {
  image = docker_image.influxdb2.latest
  name  = "jb4_influxdb2"
  networks_advanced {
    name = "${docker_network.private_network.name}"
  }
  ports {
      internal = 8086
      external = 8087
  }
  env = [
      "DOCKER_INFLUXDB_INIT_MODE=setup",
      "DOCKER_INFLUXDB_INIT_USERNAME=admin",
      "DOCKER_INFLUXDB_INIT_PASSWORD=${random_password.influxdb_admin_password.result}",
      "DOCKER_INFLUXDB_INIT_ORG=org0",
      "DOCKER_INFLUXDB_INIT_BUCKET=bucket0",
      "DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=${random_password.influxdb_admin_token.result}"
  ]
}

## Outputs

output "influxdb_admin_password" {
  value = random_password.influxdb_admin_password.result
  sensitive = true
}

output "influxdb_admin_token" {
  value = random_password.influxdb_admin_token.result
  sensitive = true
}

output "grafana_admin_password" {
  value = random_password.grafana_admin_password.result
  sensitive = true
}