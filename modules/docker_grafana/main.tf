terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.16.0"
    }
    grafana = {
      source = "grafana/grafana"
      version = "1.22.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "grafana" {
  name = "grafana/grafana-oss:8.2.6"
}

resource "docker_volume" "grafana_volume" {
  name = "${var.docker_volume_name}"
}

// https://grafana.com/docs/grafana/latest/administration/configure-docker/
resource "docker_container" "grafana_container" {
  image = docker_image.grafana.latest
  name  = "${var.docker_container_name}"
  volumes {
    volume_name = "${docker_volume.grafana_volume.name}"
    container_path = "/var/lib/grafana"
  }
  networks_advanced {
    name = "${var.docker_net_name}"
  }
  ports {
      internal = 3000
      external = 3001
  }
  env = [
      "GF_SECURITY_ADMIN_USER=${var.admin_username}",
      "GF_SECURITY_ADMIN_PASSWORD=${var.admin_password}"
  ]
}



# resource "grafana_organization" "my_org" {
#   provider = grafana.base
#   name     = "Testing123"
# }

# resource "grafana_data_source" "influxdb" {
#   type          = "influxdb"
#   name          = "myapp-metrics"
#   url           = "http://jb4-influxdb2:8086/"
#   username      = "myapp"
#   password      = "foobarbaz"
#   json_data {
#     organization = "MyOrg"
#     default_bucket = "MyBucket" 
#   }
# }
