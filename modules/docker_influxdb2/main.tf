terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "influxdb2" {
  name = "influxdb:2.2"
}

# https://hub.docker.com/_/influxdb
resource "docker_container" "influxdb2_container" {
  image = docker_image.influxdb2.latest
  name  = "${var.docker_container_name}"
  networks_advanced {
    name = "${var.docker_net_name}"
  }
  ports {
      internal = 8086
      external = 8087
  }
  env = [
      "DOCKER_INFLUXDB_INIT_MODE=setup",
      "DOCKER_INFLUXDB_INIT_USERNAME=${var.admin_username}",
      "DOCKER_INFLUXDB_INIT_PASSWORD=${var.admin_password}",
      "DOCKER_INFLUXDB_INIT_ORG=${var.org}",
      "DOCKER_INFLUXDB_INIT_BUCKET=${var.bucket}",
      "DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=${var.admin_token}"
  ]
}
