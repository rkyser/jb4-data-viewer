
variable "grafana_admin_username" {
  type = string
  default = "admin"
  description = "This configures the Grafana admin account with the provided username"
}

variable "grafana_admin_password" {
  type = string
  default = "password"
  sensitive = true
  description = "This configures the Grafana admin account with the provided password"
}

variable "influxdb2_admin_username" {
  type = string
  default = "admin"
  description = "This configures the InfluxDB2 admin account with the provided username"
}

variable "influxdb2_admin_password" {
  type = string
  default = "password"
  sensitive = true
  description = "This configures the InfluxDB2 admin account with the provided password"
}
