# Provider credentials
variable "api_key" {}

# General variables
variable "is_production" {}
variable "frontend_count" {}
variable "backend_count" {}

# Environment
variable "service_code" {}
variable "organization_code" {}
variable "environment_name" {}

variable "environment_description" {
  default = "Environment for %s workloads"
}


variable "admin" {
  type = "list"
}

variable "read_only" {
  type = "list"
}

# VPC
variable "vpc_offering" {
  default = "Default VPC offering"
}
variable "zone_id" {
  default = "QC-2"
}
variable "vpc_description" {
  default = "VPC for %s workloads"
}

# Networks
variable "web_network_description" {
  default = "Web network"
}

variable "db_network_description" {
  default = "Database network"
}

variable "tools_network_description" {
  default = "Tools network"
}

# Instances
variable "template_name" {
  default = "CoreOS Stable"
}

variable "username" {
  default = "core"
}

variable "compute_offering" {
  default = "1vCPU.1GB"
}

variable "db_volume_offering" {
  default = "20GB - 20 IOPS Min."
}
variable "database_ports" {
  default = [ 3306 ]
}
variable "web_ports" {
  default = [ 80, 443 ]
}
