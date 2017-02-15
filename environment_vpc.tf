resource "cloudca_environment" "default" {
  service_code      = "${var.service_code}"
  organization_code = "${var.organization_code}"
  name              = "${var.environment_name}"
  description       = "${format("${var.environment_description}", "${var.environment_name}")}"
  admin_role        = ["${var.admin}"]
  read_only_role    = ["${var.read_only}"]
}

resource "cloudca_vpc" "default" {
  environment_id = "${cloudca_environment.default.id}"
  name           = "${var.environment_name}"
  description    = "${format("${var.vpc_description}", "${var.environment_name}")}"
  vpc_offering   = "${var.vpc_offering}"
  zone           = "${var.zone_id}"
}

resource "cloudca_public_ip" "public_endpoint" {
  environment_id = "${cloudca_environment.default.id}"
  vpc_id         = "${cloudca_vpc.default.id}"
}
