variable "aws_ssh_public_key" {

}

variable "aws_ssh_private_key" {

}

variable "aws_key_name" {
  description = "Desired name of AWS key pair"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}


# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-674cbc1e"
    us-east-1 = "ami-1d4e7a66"
    us-west-1 = "ami-969ab1f6"
    us-west-2 = "ami-8803e0f0"
  }
}


variable "digitalOcean_token" {
  default = ""
}

variable "digitalocean_ssh_public_key" {
  default = ""
}

variable "digitalocean_ssh_private_key" {
  default = ""
}

variable "stackpath_client_id" {
  default = ""
}

variable "stackpath_api_client_secret" {
  default = ""
}

variable "stackpath_stack" {
  default = ""
}
