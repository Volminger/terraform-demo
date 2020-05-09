Terraform Cloud Cross Provider Demo
=========
- Link to demo: https://youtu.be/4X-P2ltLJto
- Terraform workspace: https://app.terraform.io/app/KTH-DevOps

<img alt="Terraform" src="https://www.terraform.io/assets/images/logo-hashicorp-3f10732f.svg" width="600px">

# Cross Provider Demo
With the rise of cloud computing infrastructure have started to become more and more flexible and modular, just like code. So why should you not treat your infrastructure as code (IaC)? There are several players that enables IaC, but most of them only offer it with their own infrastructure platform. This can be a limitation for those who do not want to get tied down to one provider. HashiCorp’s Terraform is an open-source IaC solution that works cross-cloud and data centers. Simply write your infrastructure in Hashicorp Configuration Language (HCL) and watch as your infrastructure get built. HashiCorp recently launched Terraform Cloud to the public, which is is a SaaS solution of Terraform Enterprise. It enables easy CI/CD and collaboration on your infrastructure code. 

In this demo we use Terraform Cloud to setup a infrastructure solution that works across multiple cloud providers. A [traefik](https://docs.traefik.io/) load-balancer is set up as a Docker container in [Stackpath](https://www.stackpath.com/). This load-balancer is then connected to a [NGINX](https://www.nginx.com/) web-server running in an [EC2](https://aws.amazon.com/ec2/) instance at [AWS](https://aws.amazon.com/) and another [NGINX](https://www.nginx.com/) web-server running in a [Droplet](https://www.digitalocean.com/docs/droplets/) instance at [DigitalOcean](https://www.digitalocean.com/).

![](demo/cross_provider_demo.png)

![](demo/digitalOcean_proxied.png)

![](demo/aws_proxied.png)


# Resources
- Terraform Website: https://www.terraform.io
- Terraform Cloud: https://app.terraform.io/app
- Documentation: [https://www.terraform.io/docs/](https://www.terraform.io/docs/)
- Tutorials: [HashiCorp's Learn Platform](https://learn.hashicorp.com/terraform)

