provider "digitalocean" {
  token = var.digitalOcean-token
}

resource "digitalocean_droplet" "www-1" {
    connection {
      user = "root"
      type = "ssh"
      private_key = var.ssh_private_key
      host = self.public_ip
      timeout = "2m"
    }

    image = "ubuntu-14-04-x64"
    name = "www-1"
    region = "nyc2"
    size = "512mb"
    ssh_keys = [
      var.ssh_public_key
    ]

    provisioner "remote-exec" {
      inline = [
        "export PATH=$PATH:/usr/bin",
        # install nginx
        "sudo apt-get update",
        "sudo apt-get -y install nginx"
      ]
    }
}
