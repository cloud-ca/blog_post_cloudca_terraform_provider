resource "cloudca_instance" "web_instance" {
  count = 2
  service_code = "${var.service_code}"
  environment_name = "${cloudca_environment.default.name}"
  name = "${format("%s-web-%02d", "${var.environment_name}", count.index + 1)}"
  network_id = "${cloudca_tier.web_tier.id}"
  template = "${var.template_name}"
  compute_offering = "${var.compute_offering}"
  purge = true
}

resource "cloudca_public_ip" "public_endpoint" {
  service_code = "${var.service_code}"
  environment_name = "${cloudca_environment.default.name}"
  vpc_id = "${cloudca_vpc.default.id}"
}

resource "cloudca_load_balancer_rule" "lbr" {
  service_code = "${var.service_code}"
  environment_name = "${cloudca_environment.default.name}"
  name="${var.lbr_name}"
  public_ip_id="${cloudca_public_ip.public_endpoint.id}"
  protocol="tcp"
  algorithm = "leastconn"
  public_port = 80
  private_port = 80
  #instance_ids = [ "${formatlist("%s", cloudca_instance.web_instance.*.id)}" ]
  instance_ids = [ "47c5fc40-4a6e-4ebc-8573-cdc5c50729ae" ]

  stickiness_method = "AppCookie"
  stickiness_params {
    cookieName = "web_app_cookie"
  }
}

resource "cloudca_instance" "db_instance" {
  service_code = "${var.service_code}"
  environment_name = "${cloudca_environment.default.name}"
  name = "${var.environment_name}-db-01"
  network_id = "${cloudca_tier.db_tier.id}"
  template = "${var.template_name}"
  compute_offering = "${var.compute_offering}"
  purge = true
}

resource "cloudca_volume" "db_volume" {
  service_code = "${var.service_code}"
  environment_name = "${cloudca_environment.default.name}"

  name = "DATA_${cloudca_instance.db_instance.name}"

  disk_offering = "${var.db_volume_name}"
  instance_id = "${cloudca_instance.db_instance.id}"
}

resource "cloudca_instance" "tools_instance" {
  count = "${var.environment_name == "prod" ? 1 : 0}"
  service_code = "${var.service_code}"
  environment_name = "${cloudca_environment.default.name}"
  name = "${var.environment_name}-tools-01"
  network_id = "${cloudca_tier.tools_tier.id}"
  template = "${var.template_name}"
  compute_offering = "${var.compute_offering}"
  purge = true
}
