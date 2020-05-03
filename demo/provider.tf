provider "aws" {
  region = var.aws_region
}

provider "stackpath" {
  stack_id         = var.stackpath_stack
  client_id     = var.stackpath_client_id
  client_secret = var.stackpath_api_client_secret
}

provider "digitalocean" {
  token = var.digitalOcean-token
}
