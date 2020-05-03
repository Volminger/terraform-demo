resource "digitalocean_ssh_key" "default" {
  name       = "Terraform Demo"
  public_key = var.aws_ssh_public_key
}

resource "digitalocean_droplet" "instance_1" {
    connection {
      user = "root"
      type = "ssh"
      private_key = var.aws_ssh_private_key
      host = self.ipv4_address
      timeout = "2m"
    }

    image = "ubuntu-18-04-x64"
    name = "instance-1"
    region = "LON1"
    size = "512mb"
    ssh_keys = [digitalocean_ssh_key.default.fingerprint]

    provisioner "remote-exec" {
      inline = [
        "export PATH=$PATH:/usr/bin",
        # install nginx
        "sudo apt-get update",
        "sudo apt-get -y install nginx",
        "curl https://github.com/Volminger/terraform-demo/tree/master/demo/digitalocean_instance_index.html -o index.html",
        "sudo cp index.html /var/www/html/index.html"
      ]
    }
}
