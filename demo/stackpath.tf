resource "stackpath_compute_workload" "traefik-lb" {
  name = "traefik-lb"
  slug = "traefik-lb"


  network_interface {
    network = "default"
  }

  container {
    name = "app"
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
        # scale up when CPU averages 50%
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

resource "stackpath_compute_network_policy" "web-server" {
  name        = "Allow HTTP traffic for web servers"
  slug        = "web-servers-allow-http"
  description = "A network policy for allowing HTTP access for instances with the web server role"

  instance_selector {
    key      = "workload.platform.stackpath.net/workload-slug"
    operator = "in"
    values   = ["traefik-lb"]
  }


  priority     = 100
  policy_types = ["INGRESS", "EGRESS"]

  # Allow all inbound connections destined for port 80
  ingress {
    description = "Allow all outbound connections on both TCP and UDP"
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
