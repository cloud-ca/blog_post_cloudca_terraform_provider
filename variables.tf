provider "cloudca" {
  api_key = "${var.api_key}"
}

variable "zone_id" {
  default = "QC-2"
}

variable "api_key" {}
variable "service_code" {}
variable "organization_code" {}
variable "environment_name" {}

variable "admin" {
  type = "list"
}

variable "read_only" {
  type = "list"
}

variable "frontend_count" {}
variable "backend_count" {}

variable "vpc_offering" {
  default = "Default VPC offering"
}

variable "environment_description" {
  default = "Environment for %s workloads"
}

variable "vpc_description" {
  default = "VPC for %s workloads"
}

variable "template_name" {
  default = "CoreOS Stable"
}

variable "username" {
  default = "core"
}

variable "compute_offering" {
  default = "1vCPU.1GB"
}

variable "lbr_name" {
  default = "web_instances"
}

variable "db_volume_name" {
  default = "20GB - 20 IOPS Min."
}
