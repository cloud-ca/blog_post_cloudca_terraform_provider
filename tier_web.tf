resource "cloudca_tier" "web_tier" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    name = "web_network"
    description = "Web network"
    vpc_id = "${cloudca_vpc.default.id}"
    network_offering = "Load Balanced Tier"
    network_acl_id = "${cloudca_network_acl.web_acl.id}"
}

resource "cloudca_network_acl" "web_acl" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    name = "web_acl"
    description = "Web ACL"
    vpc_id = "${cloudca_vpc.default.id}"
}

resource "cloudca_network_acl_rule" "web_allow_in_22" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    rule_number = 1
    action = "Allow"
    protocol = "TCP"
    start_port = 22
    end_port = 22
    cidr = "${var.environment_name == "production" ? "${cloudca_instance.tools_instance.private_ip}/32" : "0.0.0.0/0" }"
    traffic_type = "Ingress"
    network_acl_id = "${cloudca_network_acl.web_acl.id}"
}

resource "cloudca_network_acl_rule" "web_allow_in_80" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    rule_number = 5
    action = "Allow"
    protocol = "TCP"
    start_port = 80
    end_port = 80
    cidr = "0.0.0.0/0"
    traffic_type = "Ingress"
    network_acl_id = "${cloudca_network_acl.web_acl.id}"
}

resource "cloudca_network_acl_rule" "web_allow_in_443" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    rule_number = 6
    action = "Allow"
    protocol = "TCP"
    start_port = 443
    end_port = 443
    cidr = "0.0.0.0/0"
    traffic_type = "Ingress"
    network_acl_id = "${cloudca_network_acl.web_acl.id}"
}

resource "cloudca_network_acl_rule" "web_all_out_all" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    rule_number = 90
    action = "Allow"
    protocol = "All"
    cidr = "0.0.0.0/0"
    traffic_type = "Egress"
    network_acl_id = "${cloudca_network_acl.web_acl.id}"
}

resource "cloudca_network_acl_rule" "web_deny_in_all" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    rule_number = 100
    action = "Deny"
    protocol = "All"
    cidr = "0.0.0.0/0"
    traffic_type = "Ingress"
    network_acl_id = "${cloudca_network_acl.web_acl.id}"
}
