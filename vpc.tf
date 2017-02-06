resource "cloudca_vpc" "default" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    name = "${var.vpc_name}"
    description = "${var.vpc_description}"
    vpc_offering = "Default VPC offering"
# TODO: add zone id
}
