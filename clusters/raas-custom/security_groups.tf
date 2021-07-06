
// CITY NETWORK
resource "openstack_networking_secgroup_v2" "citynetwork" {
  name = "${var.prefix}-ssh-citynetwork"
}

resource "openstack_networking_secgroup_rule_v2" "in-22-city" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = ""
  security_group_id = openstack_networking_secgroup_v2.citynetwork.id
}

// CUSTOMER
resource "openstack_networking_secgroup_v2" "customer" {
  name = "${var.prefix}-ssh"
}

resource "openstack_networking_secgroup_rule_v2" "in-22-customer" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = var.customer_vpn
  security_group_id = openstack_networking_secgroup_v2.customer.id
}

// RANCHER
// https://rancher.com/docs/rke/latest/en/os/#ports

resource "openstack_networking_secgroup_v2" "rancher" {
  name = "${var.prefix}-rancher"
}

resource "openstack_networking_secgroup_rule_v2" "in-22" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "10.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-80" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

// Canal Network plugin
resource "openstack_networking_secgroup_rule_v2" "in-179" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 179
  port_range_max = 179
  remote_ip_prefix = var.cidr
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-443" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 443
  port_range_max = 443
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-2376" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 2376
  port_range_max = 2376
  remote_ip_prefix = var.cidr
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-2379" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 2379
  port_range_max = 2379
  remote_ip_prefix = var.cidr
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-2380" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 2380
  port_range_max = 2380
  remote_ip_prefix = var.cidr
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-4789" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 4789
  port_range_max = 4789
  remote_ip_prefix = var.cidr
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-6443" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 6443
  port_range_max = 6443
  remote_ip_prefix = var.cidr
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-8472" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "udp"
  port_range_min = 8472
  port_range_max = 8472
  remote_ip_prefix = var.cidr
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-9099" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 9099
  port_range_max = 9099
  remote_ip_prefix = var.cidr
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-9796" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 9796
  port_range_max = 9796
  remote_ip_prefix = var.cidr
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-10250" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 10250
  port_range_max = 10250
  remote_ip_prefix = var.cidr
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-10254" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 10254
  port_range_max = 10254
  remote_ip_prefix = var.cidr
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-node-port-tcp" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 30000
  port_range_max = 32767
  remote_ip_prefix = var.cidr
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

resource "openstack_networking_secgroup_rule_v2" "in-node-port-udp" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "udp"
  port_range_min = 30000
  port_range_max = 32767
  remote_ip_prefix = var.cidr
  security_group_id = openstack_networking_secgroup_v2.rancher.id
}

// MASTER EXTRA
/*
resource "openstack_networking_secgroup_v2" "master-extra" {
  name = "${var.prefix}-workload-extra"
}
*/

// WORKER EXTRA
/*
resource "openstack_networking_secgroup_v2" "workload-extra" {
  name = "${var.prefix}-workload-extra"
}
*/