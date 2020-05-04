output "load-balancer-public-ip" {
  value = stackpath_compute_workload.load-balancer.instances[0].external_ip_address

  depends_on = [stackpath_compute_workload.load-balancer.instances[0]]
}

output "lord_of_them_all" {
  value = "One IaC to rule them all, One IaC to find them, One IaC to bring them all and in Terraform bind them."
}
