output "traefik-workload-instances" {
  value = {
    for instance in stackpath_compute_workload.traefik-lb.instances :
    instance.name => {
      "ip_address" = "${instance.external_ip_address}"
      "phase"      = instance.phase
    }
  }
}
