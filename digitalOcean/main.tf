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


    user_data     = <<EOT
#cloud-config
# update apt on boot
package_update: true
# install nginx
packages:
- nginx
write_files:
- content: |
  <!DOCTYPE html>
  <html>
  <head>
    <title>StackPath - Amazon Web Services Instance</title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <style>
      html, body {
        background: #000;
        height: 100%;
        width: 100%;
        padding: 0;
        margin: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        flex-flow: column;
      }
      img { width: 250px; }
      svg { padding: 0 40px; }
      p {
        color: #fff;
        font-family: 'Courier New', Courier, monospace;
        text-align: center;
        padding: 10px 30px;
      }
    </style>
  </head>
  <body>
    <img src="https://www.stackpath.com/content/images/logo-and-branding/stackpath-logo-standard-screen.svg">
    <p>This request was proxied from <strong>Amazon Web Services</strong></p>
  </body>
  </html>

path: /usr/share/app/index.html
permissions: '0644'
runcmd:
- cp /usr/share/app/index.html /usr/share/nginx/html/index.html
EOT


}
