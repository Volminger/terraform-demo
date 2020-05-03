provider "digitalocean" {
  token = var.digitalOcean-token
}

resource "digitalocean_ssh_key" "demoKey" {
  name       = "Terraform Demo"
  public_key = var.ssh_public_key
}

resource "digitalocean_droplet" "www-1" {
    connection {
      user = "root"
      type = "ssh"
      private_key = var.ssh_private_key
      host = self.ipv4_address
      timeout = "2m"
    }

    image = "ubuntu-18-04-x64"
    name = "www-1"
    region = "LON1"
    size = "512mb"
    ssh_keys = [digitalocean_ssh_key.demoKey.fingerprint]

    provisioner "remote-exec" {
      inline = [
        "export PATH=$PATH:/usr/bin",
        # install nginx
        "sudo apt-get update",
        "sudo apt-get -y install nginx",
        cat /var/www/html/index.html,
        <!DOCTYPE html>
        <html>
        <head>
          <title>Digital Ocean</title>
          <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
        </head>
        <body>
          <img src="https://www.google.com/url?sa=i&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FDigitalOcean&psig=AOvVaw1u5RaZkciJkLdWiPTXq3dI&ust=1588601536984000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCMCv-4Twl-kCFQAAAAAdAAAAABAD">
          <p>This request was proxied from <strong>Digital Ocean</strong></p>
        </body>
        </html>
        EOF
      ]
    }
}
