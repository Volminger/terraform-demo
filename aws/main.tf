# Specify the provider and access details
provider "aws" {
  region = var.aws_region
}

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elb" {
  name        = "terraform_example_elb"
  description = "Used in the terraform"
  vpc_id      =  aws_vpc.default.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "terraform_example"
  description = "Used in the terraform"
  vpc_id      = aws_vpc.default.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "web" {
  name = "terraform-example-elb"

  subnets         = [aws_subnet.default.id]
  security_groups = [aws_security_group.elb.id]
  instances       = [aws_instance.web.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_instance" "web" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ubuntu"
    host = self.public_ip
    type     = "ssh"
    private_key = var.private_key
  }

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

  instance_type = "t3a.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = lookup(var.aws_amis, var.aws_region)

  # The name of our SSH keypair we created above.
  key_name = aws_key_pair.auth.id

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = [aws_security_group.default.id]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = aws_subnet.default.id


}
