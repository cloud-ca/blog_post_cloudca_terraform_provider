resource "cloudca_environment" "default" {
    service_code = "${var.service_code}"
    organization_code = "${var.organization_code}"
    name = "${var.environment_name}"
    description = "${format("${var.environment_description}", "${var.environment_name}")}"
    admin_role = [ "${var.admin}" ]
    read_only_role = [ "${var.read_only}" ]
}

resource "cloudca_vpc" "default" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    name = "${var.environment_name}"
    description = "${var.vpc_description}"
    vpc_offering = "Default VPC offering"
    zone = "${var.zone_id}"
}
