resource "cloudca_environment" "default" {
    service_code = "${var.service_code}"
    organization_code = "${var.organization_code}"
    name = "${var.environment_name}"
    description = "${var.environment_description}"
    admin_role = "${split(",", "${var.admin}")}" #TODO: use list in variables
    read_only_role = "${split(",", "${var.read_only}")}"
}
