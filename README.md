# JB4 Data Viewer

This app can be used to view and analyze data exported from a JB4 tuner. It is a work-in-progress at this point.

## Setup Requirements

1. Docker
2. Python3
3. Terraform

## Getting Started

Clone or download this repo.

Run the following Terraform commands to initialize Grafana w/ InfluxDB2 Docker containers.

```
terraform init
terraform plan
terraform apply
```

## Grafana Queries

### RPM

```
from(bucket: "jb4")
  |> range(start: -6h)
  |> filter(fn: (r) => r._measurement == "sample" and (r._field == "rpm" or r._field == "gear"))
  |> yield()
```
