output "load-balancer-public-ip" {
  value = stackpath_compute_workload.load-balancer.instances[0].external_ip_address
}
