provider "stackpath" {
  stack_id         = var.stackpath_stack
  client_id     = var.stackpath_client_id
  client_secret = var.stackpath_api_client_secret
}

resource "stackpath_compute_workload" "traefik-lb" {
  name = "traefik-lb"
  slug = "traefik-lb"


  network_interface {
    network = "default"
  }

  container {
    # Name that should be given to the container
    name = "app"
    # Nginx image to use for the container
    image = "scotwells/multi-cloud-traefik:latest"
    # Override the command that's used to execute
    # the container. If this option is not provided
    # the default entrypoint and command defined
    # by the docker image will be used.
    # command = []
    resources {
      requests = {
        "cpu"    = "1"
        "memory" = "2Gi"
      }
    }
    # Deploy these 1 to 2 instances in Dallas, TX, USA and Amsterdam, NL.
    deployment_scope = "cityCode"
    selector {
      key      = "cityCode"
      operator = "in"
      values   = [
        "DFW", "AMS"
      ]
    }

    env {
      key   = "BACKEND_1"
      value = "http://terraform-example-elb-655058968.us-west-2.elb.amazonaws.com/"
    }

    env {
      key   = "BACKEND_2"
      value = "http://206.189.122.128/"
    }
  }

  target {
    name         = "us"
    min_replicas = 1
    max_replicas = 2
    scale_settings {
      metrics {
        metric = "cpu"
        # scale up when CPU averages 50%
        average_utilization = 50
      }
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
