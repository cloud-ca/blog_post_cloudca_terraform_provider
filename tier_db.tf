resource "cloudca_tier" "db_tier" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    name = "database_network"
    description = "Database network"
    vpc_id = "${cloudca_vpc.default.id}"
    network_offering = "Standard Tier"
    network_acl_id = "${cloudca_network_acl.db_acl.id}"
}

resource "cloudca_network_acl" "db_acl" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    name = "database_acl"
    description = "Database ACL"
    vpc_id = "${cloudca_vpc.default.id}"
}

resource "cloudca_network_acl_rule" "db_allow_in_22" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    rule_number = 1
    action = "Allow"
    protocol = "TCP"
    start_port = 22
    end_port = 22
    cidr = "${var.environment_name == "production" ? "${cloudca_instance.tools_instance.private_ip}/32" : "0.0.0.0/0" }"
    traffic_type = "Ingress"
    network_acl_id = "${cloudca_network_acl.db_acl.id}"
}

resource "cloudca_network_acl_rule" "db_allow_in_3306" {
    count = "${var.environment_name == "production" ? "${var.frontend_count}" : 1}"
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    rule_number = "${10 + count.index + 1}"
    action = "Allow"
    protocol = "TCP"
    start_port = 3306
    end_port = 3306
    cidr = "${var.environment_name == "production" ? "${element(cloudca_instance.tools_instance.*.private_ip, count.index)}/32" : "0.0.0.0/0" }"
    traffic_type = "Ingress"
    network_acl_id = "${cloudca_network_acl.db_acl.id}"
}

resource "cloudca_network_acl_rule" "db_all_out_all" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    rule_number = 90
    action = "Allow"
    protocol = "All"
    cidr = "0.0.0.0/0"
    traffic_type = "Egress"
    network_acl_id = "${cloudca_network_acl.db_acl.id}"
}

resource "cloudca_network_acl_rule" "db_deny_in_all" {
    service_code = "${var.service_code}"
    environment_name = "${cloudca_environment.default.name}"
    rule_number = 100
    action = "Deny"
    protocol = "All"
    cidr = "0.0.0.0/0"
    traffic_type = "Ingress"
    network_acl_id = "${cloudca_network_acl.db_acl.id}"
}

