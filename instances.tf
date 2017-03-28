data "template_file" "cloudinit" {
  template = "${file("./cloudinit.tpl")}"

  vars {
    public_key  = "${replace(file("./id_rsa.pub"), "\n", "")}"
    private_key = "${file("./id_rsa")}"
    username    = "${var.username}"
  }
}

resource "cloudca_instance" "web_instance" {
  environment_id   = "${cloudca_environment.default.id}"
  count            = "${var.frontend_count}"
  name             = "${format("%s-web-%02d", "${var.environment_name}", count.index + 1)}"
  network_id       = "${cloudca_network.web_network.id}"
  template         = "${var.template_name}"
  compute_offering = "${var.compute_offering}"
  user_data        = "${data.template_file.cloudinit.rendered}"
}

resource "cloudca_load_balancer_rule" "lbr" {
  environment_id    = "${cloudca_environment.default.id}"
  count             = "${length(var.web_ports)}"
  name              = "web_instances_${element(var.web_ports, count.index)}"
  public_ip_id      = "${cloudca_public_ip.public_endpoint.id}"
  network_id        = "${cloudca_network.web_network.id}"
  protocol          = "tcp"
  algorithm         = "leastconn"
  public_port       = "${element(var.web_ports, count.index)}"
  private_port      = "${element(var.web_ports, count.index)}"
  instance_ids      = ["${cloudca_instance.web_instance.*.id}"]
  stickiness_method = "AppCookie"

  stickiness_params {
    cookieName = "web_app_cookie"
  }
}

resource "cloudca_instance" "db_instance" {
  environment_id   = "${cloudca_environment.default.id}"
  count            = "${var.backend_count}"
  name             = "${format("%s-db-%02d", "${var.environment_name}", count.index + 1)}"
  network_id       = "${cloudca_network.db_network.id}"
  template         = "${var.template_name}"
  compute_offering = "${var.compute_offering}"
  user_data        = "${data.template_file.cloudinit.rendered}"
}

resource "cloudca_volume" "db_volume" {
  environment_id = "${cloudca_environment.default.id}"
  count          = "${var.backend_count}"

  name = "DATA_${element(cloudca_instance.db_instance.*.name, count.index)}"

  disk_offering = "${var.db_volume_offering}"
  instance_id   = "${element(cloudca_instance.db_instance.*.id, count.index)}"
}

resource "cloudca_instance" "tools_instance" {
  environment_id   = "${cloudca_environment.default.id}"
  name             = "${var.environment_name}-tools-01"
  network_id       = "${cloudca_network.tools_network.id}"
  template         = "${var.template_name}"
  compute_offering = "${var.compute_offering}"
  user_data        = "${data.template_file.cloudinit.rendered}"
}

resource "cloudca_public_ip" "tools_ssh" {
  environment_id = "${cloudca_environment.default.id}"
  vpc_id         = "${cloudca_vpc.default.id}"
}

resource "cloudca_port_forwarding_rule" "tools_ssh" {
  environment_id = "${cloudca_environment.default.id}"

  public_ip_id      = "${cloudca_public_ip.tools_ssh.id}"
  public_port_start = 22
  private_ip_id     = "${cloudca_instance.tools_instance.private_ip_id}"

  private_port_start = 22
  protocol           = "TCP"
}

output "ssh" {
  value = "Connect with ssh via `ssh ${username}@${cloudca_public_ip.tools_ssh.public_ip}"
}
