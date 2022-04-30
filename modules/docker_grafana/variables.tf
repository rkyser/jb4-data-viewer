variable "docker_net_name" {
  type = string
  description = "The network name to attach the Grafana container to"
}

variable "docker_volume_name" {
  type = string
  default = "grafana-vol"
  description = "The name of the Docker volume to create for the Granfana container instance"
}

variable "docker_container_name" {
  type = string
  default = "grafana"
  description = "The name of the Grafana Docker container"
}

variable "admin_username" {
  type = string
  default = "admin"
  description = "This configures the Grafana admin account with the provided username"
}

variable "admin_password" {
  type = string
  sensitive = true
  description = "This configures the Grafana admin account with the provided password"
}
