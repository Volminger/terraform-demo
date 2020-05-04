resource "stackpath_compute_workload" "load-balancer" {
  name = "load-balancer"
  slug = "load-balancer"


  network_interface {
    network = "default"
  }

  container {
    name = "load-balancer-container"
    # Nginx image to use for the container
    image = "scotwells/multi-cloud-traefik:latest"
    resources {
      requests = {
        "cpu"    = "1"
        "memory" = "2Gi"
      }
    }


    env {
      key   = "BACKEND_1"
      value = "http://${aws_instance.terraform_demo.public_ip}/"
    }

    env {
      key   = "BACKEND_2"
      value = "http://${digitalocean_droplet.instance_1.ipv4_address}"
    }
  }

  target {
    name         = "us"
    min_replicas = 1
    max_replicas = 1
    scale_settings {
      metrics {
        metric = "cpu"
        average_utilization = 50
      }
    }
    # Deploy these one instances in Amsterdam, NL.
    deployment_scope = "cityCode"
    selector {
      key      = "cityCode"
      operator = "in"
      values   = [
        "AMS"
      ]
    }
  }
}

resource "stackpath_compute_network_policy" "load-balancer" {
  name        = "Allow all HTTP traffic for load balancer"
  slug        = "load-balancer-servers-allow-http"
  description = "A network policy for allowing HTTP access to load balancer"

  instance_selector {
    key      = "workload.platform.stackpath.net/workload-slug"
    operator = "in"
    values   = ["load-balancer"]
  }

  priority     = 100
  policy_types = ["INGRESS", "EGRESS"]

  # Allow all inbound connections destined for port 80
  ingress {
    description = "Allow all inbound connections on both TCP and UDP on port 80"
    action      = "ALLOW"
    protocol {
      tcp_udp {
        destination_ports = [80]
      }
    }
    from {
      ip_block {
        cidr = "0.0.0.0/0"
      }
    }
  }

  # Allows all outbound connections to 0.0.0.0/0
  egress {
    description = "Allow all outbound connections on both TCP and UDP"
    action      = "ALLOW"
    to {
      ip_block {
        cidr = "0.0.0.0/0"
      }
    }
  }
}
