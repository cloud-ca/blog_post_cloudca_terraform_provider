resource "cloudca_tier" "tools_network" {
  environment_id   = "${cloudca_environment.default.id}"
  name             = "tools_network"
  description      = "Tools network"
  vpc_id           = "${cloudca_vpc.default.id}"
  network_offering = "Standard Tier"
  network_acl_id   = "${cloudca_network_acl.tools_acl.id}"
}

resource "cloudca_network_acl" "tools_acl" {
  environment_id = "${cloudca_environment.default.id}"
  name           = "tools_acl"
  description    = "Tools ACL"
  vpc_id         = "${cloudca_vpc.default.id}"
}

resource "cloudca_network_acl_rule" "tools_allow_in_22" {
  environment_id = "${cloudca_environment.default.id}"
  rule_number    = 1
  action         = "Allow"
  protocol       = "TCP"
  start_port     = 22
  end_port       = 22
  cidr           = "0.0.0.0/0"
  traffic_type   = "Ingress"
  network_acl_id = "${cloudca_network_acl.tools_acl.id}"
}

resource "cloudca_network_acl_rule" "tools_all_out_all" {
  environment_id = "${cloudca_environment.default.id}"
  rule_number    = 90
  action         = "Allow"
  protocol       = "All"
  cidr           = "0.0.0.0/0"
  traffic_type   = "Egress"
  network_acl_id = "${cloudca_network_acl.tools_acl.id}"
}

resource "cloudca_network_acl_rule" "tools_deny_in_all" {
  environment_id = "${cloudca_environment.default.id}"
  rule_number    = 100
  action         = "Deny"
  protocol       = "All"
  cidr           = "0.0.0.0/0"
  traffic_type   = "Ingress"
  network_acl_id = "${cloudca_network_acl.tools_acl.id}"
}
