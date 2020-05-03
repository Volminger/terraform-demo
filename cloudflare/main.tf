provider "cloudflare" {
  version = "~> 2.0"
  email   = var.cloudflare_email
  api_token = var.cloudflare_api_token
}

resource "cloudflare_load_balancer" "bar" {
  zone_id = "d41d8cd98f00b204e9800998ecf8427e"
  name = "example-load-balancer"
  fallback_pool_id = cloudflare_load_balancer_pool.foo.id
  default_pool_ids = [cloudflare_load_balancer_pool.foo.id]
  description = "example load balancer using geo-balancing"
  proxied = true
  steering_policy = "geo"
  pop_pools {
    pop = "LAX"
    pool_ids = [cloudflare_load_balancer_pool.foo.id]
  }
  region_pools {
    region = "WNAM"
    pool_ids = [cloudflare_load_balancer_pool.foo.id]
  }
}

resource "cloudflare_load_balancer_pool" "foo" {
  name = "example-lb-pool"
  origins {
    name = "example-1"
    address = "161.35.39.237"
    enabled = false
  }
}
