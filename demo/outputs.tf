output "load-balancer-public-ip" {
  value = replace(
    lookup(
        stackpath_compute_workload.load-balancer.annotations,
        "anycast.platform.stackpath.net/subnets",
        ""
    ),
    "/32",
    ""
  )
}

output "lord_of_them_all" {
  value = "One IaC to rule them all, One IaC to find them, One IaC to bring them all and in Terraform bind them."
}
