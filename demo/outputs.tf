# Output a StackPath compute workload's instances' name, internal IP addresses,
# and status
output "my-compute-workload-instances" {
  value = {
    for instance in stackpath_compute_workload.load-balancer.instances:
    instance.name => {
      ip_address = "${instance.external_ip_address}"
      phase      = "${instance.phase}"
    }
  }
}
