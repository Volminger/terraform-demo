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
    us-west-2 = "ami-00c9b8a76c4629076"
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
