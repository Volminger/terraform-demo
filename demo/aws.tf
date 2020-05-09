
resource "aws_vpc" "terraform_demo" {
  cidr_block = "10.0.0.0/16"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "terraform_demo" {
  vpc_id = aws_vpc.terraform_demo.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.terraform_demo.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.terraform_demo.id
}

# Create a subnet to launch our instances into
resource "aws_subnet" "terraform_demo" {
  vpc_id                  = aws_vpc.terraform_demo.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "terraform_demo" {
  name        = "terraform_demo_security_group"
  description = "Used in the terraform"
  vpc_id      =  aws_vpc.terraform_demo.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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


resource "aws_key_pair" "auth" {
  key_name   = var.aws_key_name
  public_key = var.aws_ssh_public_key
}

resource "aws_instance" "terraform_demo" {
  connection {
    user = "ubuntu"
    host = self.public_ip
    type     = "ssh"
    private_key = var.aws_ssh_private_key
  }


  instance_type = "t3a.micro"

  ami = lookup(var.aws_amis, var.aws_region)

  key_name = aws_key_pair.auth.id

  subnet_id         = aws_subnet.terraform_demo.id
  security_groups = [aws_security_group.terraform_demo.id]


  provisioner "remote-exec" {

    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
      "curl https://raw.githubusercontent.com/Volminger/terraform-demo/master/demo/aws_instance_index.html -o index.html",
      "sudo cp index.html /var/www/html/index.html"
    ]
  }
}
