
resource "openstack_lb_loadbalancer_v2" "lb" {
  name = var.prefix
  vip_subnet_id = openstack_networking_subnet_v2.subnet.id
}

resource "openstack_lb_listener_v2" "listener-http" {
  name = "${var.prefix}-http"
  protocol = "HTTP"
  protocol_port = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
  default_pool_id = openstack_lb_pool_v2.pool-http.id
}

resource "openstack_lb_listener_v2" "listener-https" {
  name = "${var.prefix}-https"
  protocol = "HTTPS"
  protocol_port = 443
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
  default_pool_id = openstack_lb_pool_v2.pool-https.id
}

resource "openstack_lb_pool_v2" "pool-http" {
  name = "${var.prefix}-http"
  lb_method = "ROUND_ROBIN"
  protocol = "HTTP"
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
}

resource "openstack_lb_pool_v2" "pool-https" {
  name = "${var.prefix}-https"
  lb_method = "ROUND_ROBIN"
  protocol = "HTTPS"
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
}

resource "openstack_lb_member_v2" "worker-http" {
  count = var.n_of_worker_nodes
  address = element(openstack_compute_instance_v2.worker.*.access_ip_v4, count.index)
  pool_id = openstack_lb_pool_v2.pool-http.id
  protocol_port = 80
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

resource "openstack_lb_member_v2" "worker-https" {
  count = var.n_of_worker_nodes
  address = element(openstack_compute_instance_v2.worker.*.access_ip_v4, count.index)
  pool_id = openstack_lb_pool_v2.pool-https.id
  protocol_port = 443
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

resource "openstack_networking_floatingip_associate_v2" "lb-fip-assoc" {
  floating_ip = var.loadbalancer_ip
  port_id = openstack_lb_loadbalancer_v2.lb.vip_port_id
  depends_on = [openstack_lb_loadbalancer_v2.lb, openstack_lb_listener_v2.listener-http, openstack_lb_listener_v2.listener-https]
}