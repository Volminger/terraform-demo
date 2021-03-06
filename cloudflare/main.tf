provider "cloudflare" {
  version = "~> 2.0"
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}


resource "cloudflare_record" "www" {
  domain  = "terraform-demo-example.com"
  name    = "www"
  value   = "203.0.113.10"
  type    = "A"
  proxied = true
}
