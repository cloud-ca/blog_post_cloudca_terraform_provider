data "template_file" "cloudinit" {
  template = "${file("./cloudinit.tpl")}"
  vars {
    public_key = "${replace(file("./id_rsa.pub"), "\n", "")}"
    private_key = "${file("./id_rsa")}"
    username = "${var.username}"
  }
}

resource "cloudca_instance" "web_instance" {
  count = "${var.frontend_count}"
  service_code = "${var.service_code}"
  environment_name = "${cloudca_environment.default.name}"
  name = "${format("%s-web-%02d", "${var.environment_name}", count.index + 1)}"
  network_id = "${cloudca_tier.web_tier.id}"
  template = "${var.template_name}"
  compute_offering = "${var.compute_offering}"
  user_data = "${data.template_file.cloudinit.rendered}"
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
  instance_ids = [ "${cloudca_instance.web_instance.*.id}" ]

  stickiness_method = "AppCookie"
  stickiness_params {
    cookieName = "web_app_cookie"
  }
}

resource "cloudca_instance" "db_instance" {
  count = "${var.backend_count}"
  service_code = "${var.service_code}"
  environment_name = "${cloudca_environment.default.name}"
  name = "${format("%s-db-%02d", "${var.environment_name}", count.index + 1)}"
  network_id = "${cloudca_tier.db_tier.id}"
  template = "${var.template_name}"
  compute_offering = "${var.compute_offering}"
  user_data = "${data.template_file.cloudinit.rendered}"
  purge = true
}

resource "cloudca_volume" "db_volume" {
  count = "${var.backend_count}"
  service_code = "${var.service_code}"
  environment_name = "${cloudca_environment.default.name}"

  name = "DATA_${element(cloudca_instance.db_instance.*.name, count.index)}"

  disk_offering = "${var.db_volume_name}"
  instance_id = "${element(cloudca_instance.db_instance.*.id, count.index)}"
}

resource "cloudca_instance" "tools_instance" {
  count = "${var.environment_name == "prod" ? 1 : 1}"
  service_code = "${var.service_code}"
  environment_name = "${cloudca_environment.default.name}"
  name = "${var.environment_name}-tools-01"
  network_id = "${cloudca_tier.tools_tier.id}"
  template = "${var.template_name}"
  compute_offering = "${var.compute_offering}"
  user_data = "${data.template_file.cloudinit.rendered}"
  purge = true
}

resource "cloudca_public_ip" "tools_ssh" {
  service_code = "${var.service_code}"
  environment_name = "${cloudca_environment.default.name}"
  vpc_id = "${cloudca_vpc.default.id}"
}

resource "cloudca_port_forwarding_rule" "tools_ssh" {
  service_code = "${var.service_code}"
  environment_name = "${cloudca_environment.default.name}"

  public_ip_id = "${cloudca_public_ip.tools_ssh.id}"
  public_port_start = 22
  private_ip_id = "${cloudca_instance.tools_instance.private_ip_id}"

  private_port_start = 22
  protocol = "TCP"
}

output "ssh" {
  value = "Connect with ssh via `ssh ${username}@${cloudca_public_ip.tools_ssh.public_ip}"
}
