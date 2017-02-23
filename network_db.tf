resource "cloudca_network" "db_network" {
  environment_id   = "${cloudca_environment.default.id}"
  name             = "database_network"
  description      = "${var.db_network_description}"
  vpc_id           = "${cloudca_vpc.default.id}"
  network_offering = "Standard Tier"
  network_acl_id   = "${cloudca_network_acl.db_acl.id}"
}

resource "cloudca_network_acl" "db_acl" {
  environment_id = "${cloudca_environment.default.id}"
  name           = "database_acl"
  description    = "Database ACL"
  vpc_id         = "${cloudca_vpc.default.id}"
}

resource "cloudca_network_acl_rule" "db_allow_in_22" {
  environment_id = "${cloudca_environment.default.id}"
  rule_number    = 1
  action         = "Allow"
  protocol       = "TCP"
  start_port     = 22
  end_port       = 22
  cidr           = "${var.is_production ? "${cloudca_instance.tools_instance.private_ip}/32" : "0.0.0.0/0" }"
  traffic_type   = "Ingress"
  network_acl_id = "${cloudca_network_acl.db_acl.id}"
}

resource "cloudca_network_acl_rule" "db_allow_in_ports" {
  environment_id = "${cloudca_environment.default.id}"
  count          = "${var.is_production ? var.frontend_count * length(var.database_ports) : 1}"
  rule_number    = "${10 + count.index + 1}"
  action         = "Allow"
  protocol       = "TCP"
  start_port     = "${element(var.database_ports, count.index % length(var.database_ports))}"
  end_port       = "${element(var.database_ports, count.index % length(var.database_ports))}"
  cidr           = "${var.is_production ? "${element(cloudca_instance.web_instance.*.private_ip, count.index)}/32" : "0.0.0.0/0" }"
  traffic_type   = "Ingress"
  network_acl_id = "${cloudca_network_acl.db_acl.id}"
}

resource "cloudca_network_acl_rule" "db_all_out_all" {
  environment_id = "${cloudca_environment.default.id}"
  rule_number    = 90
  action         = "Allow"
  protocol       = "All"
  cidr           = "0.0.0.0/0"
  traffic_type   = "Egress"
  network_acl_id = "${cloudca_network_acl.db_acl.id}"
}

resource "cloudca_network_acl_rule" "db_deny_in_all" {
  environment_id = "${cloudca_environment.default.id}"
  rule_number    = 100
  action         = "Deny"
  protocol       = "All"
  cidr           = "0.0.0.0/0"
  traffic_type   = "Ingress"
  network_acl_id = "${cloudca_network_acl.db_acl.id}"
}
