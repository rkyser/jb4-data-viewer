variable "docker_net_name" {
  type = string
  description = "The network name to attach the InfluxDB2 container to"
}

variable "docker_volume_name" {
  type = string
  default = "influxdb2-vol"
  description = "The name of the Docker volume to create for the InfluxDB2 container instance"
}

variable "docker_container_name" {
  type = string
  default = "influxdb2"
  description = "The name of the InfluxDB2 Docker container"
}

variable "admin_username" {
  type = string
  default = "admin"
  description = "This configures the InfluxDB2 admin account with the provided username"
}

variable "admin_password" {
  type = string
  sensitive = true
  description = "This configures the InfluxDB2 admin account with the provided password"
}

variable "admin_token" {
  type = string
  sensitive = true
  description = "This configures the admin token which can be used for full REST API access to InfluxDB2."
}

variable "org" {
  type = string
  default = "MyOrg"
  description = "An organization is a workspace for a group of users. All dashboards, tasks, buckets, members, etc., belong to an organization."
}

variable "bucket" {
  type = string
  default = "MyBucket"
  description = "A bucket is a named location where time series data is stored. All buckets have a retention period, a duration of time that each data point persists. InfluxDB drops all points with timestamps older than the bucket’s retention period. A bucket belongs to an organization."
}