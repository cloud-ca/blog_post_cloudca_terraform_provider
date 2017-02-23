resource "cloudca_network" "web_network" {
  environment_id   = "${cloudca_environment.default.id}"
  name             = "web_network"
  description      = "${var.web_network_description}"
  vpc_id           = "${cloudca_vpc.default.id}"
  network_offering = "Load Balanced Tier"
  network_acl_id   = "${cloudca_network_acl.web_acl.id}"
}

resource "cloudca_network_acl" "web_acl" {
  environment_id = "${cloudca_environment.default.id}"
  name           = "web_acl"
  description    = "Web ACL"
  vpc_id         = "${cloudca_vpc.default.id}"
}

resource "cloudca_network_acl_rule" "web_allow_in_22" {
  environment_id = "${cloudca_environment.default.id}"
  rule_number    = 1
  action         = "Allow"
  protocol       = "TCP"
  start_port     = 22
  end_port       = 22
  cidr           = "${var.is_production ? "${cloudca_instance.tools_instance.private_ip}/32" : "0.0.0.0/0" }"
  traffic_type   = "Ingress"
  network_acl_id = "${cloudca_network_acl.web_acl.id}"
}

resource "cloudca_network_acl_rule" "web_allow_in_ports" {
  count         = "${length(var.web_ports)}"
  environment_id = "${cloudca_environment.default.id}"
  rule_number    = "${count.index + 5}"
  action         = "Allow"
  protocol       = "TCP"
  start_port     = "${element(var.web_ports, count.index)}"
  end_port       = "${element(var.web_ports, count.index)}"
  cidr           = "0.0.0.0/0"
  traffic_type   = "Ingress"
  network_acl_id = "${cloudca_network_acl.web_acl.id}"
}

resource "cloudca_network_acl_rule" "web_all_out_all" {
  environment_id = "${cloudca_environment.default.id}"
  rule_number    = 90
  action         = "Allow"
  protocol       = "All"
  cidr           = "0.0.0.0/0"
  traffic_type   = "Egress"
  network_acl_id = "${cloudca_network_acl.web_acl.id}"
}

resource "cloudca_network_acl_rule" "web_deny_in_all" {
  environment_id = "${cloudca_environment.default.id}"
  rule_number    = 100
  action         = "Deny"
  protocol       = "All"
  cidr           = "0.0.0.0/0"
  traffic_type   = "Ingress"
  network_acl_id = "${cloudca_network_acl.web_acl.id}"
}
