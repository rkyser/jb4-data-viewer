output "influxdb2_admin_api_token" {
  value = random_password.influxdb_admin_token
  sensitive = true
}