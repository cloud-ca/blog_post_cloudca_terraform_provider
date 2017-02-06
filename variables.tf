variable "api_key" {}
variable "organization_code" {}
variable "service_code" {}
variable "environment_name" {}
variable "admin" {}
variable "read_only" {}

variable "environment_description" {
  default = "Environment for production workloads"
}
variable "vpc_name" {
  default = "my-awesome-vpc"
}
variable "vpc_description" {
  default = "VPC for production workloads"
}
variable "tier_web_name" {
  default = "web_tier"
}
variable "tier_web_description" {
  default = "Web tier"
}
variable "acl_web_name" {
  default = "web_acl"
}
variable "acl_web_description" {
  default = "ACL web tier"
}
variable "tier_db_name" {
  default = "db_tier"
}
variable "tier_db_description" {
  default = "Database tier"
}
variable "acl_db_name" {
  default = "db_acl"
}
variable "acl_db_description" {
  default = "ACL database tier"
}
variable "tier_tools_name" {
  default = "tools_tier"
}
variable "tier_tools_description" {
  default = "Tools tier"
}
variable "acl_tools_name" {
  default = "tools_acl"
}
variable "acl_tools_description" {
  default = "ACL tools tier"
}
variable "template_name" {
  default = "CentOS 7.2 HVM"
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
