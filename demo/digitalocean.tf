resource "digitalocean_ssh_key" "demoKey" {
  name       = "Terraform Demo"
  public_key = var.ssh_public_key
}

resource "digitalocean_droplet" "instance_1" {
    connection {
      user = "root"
      type = "ssh"
      private_key = var.ssh_private_key
      host = self.ipv4_address
      timeout = "2m"
    }

    image = "ubuntu-18-04-x64"
    name = "instance_1"
    region = "LON1"
    size = "512mb"
    ssh_keys = [digitalocean_ssh_key.demoKey.fingerprint]

    provisioner "remote-exec" {
      inline = [
        "export PATH=$PATH:/usr/bin",
        # install nginx
        "sudo apt-get update",
        "sudo apt-get -y install nginx"
      ]
    }
}