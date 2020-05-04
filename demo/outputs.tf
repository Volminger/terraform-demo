output "load-balancer-public-ip" {
  provisioner "local-exec" {
  command = "sleep 10"
}

  value = {
  for instance in stackpath_compute_workload.my-compute-workload.instances:
  instance.name => {
    ip_address = instance.external_ip_address
    phase      = instance.phase
  }
}

  depends_on = [stackpath_compute_workload.load-balancer.instances[0].external_ip_address]
}

output "lord_of_them_all" {

  value = "One IaC to rule them all, One IaC to find them, One IaC to bring them all and in Terraform bind them."
}
