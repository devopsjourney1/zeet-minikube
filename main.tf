terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.13.4"
}


#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance
resource "aws_lightsail_instance" "server" {
  name              = "minikube"
  availability_zone = "us-west-2a"
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "medium_2_0"
  tags = {
    environment = "development"
  }
    user_data = file("userdata.sh")
}


resource "aws_lightsail_instance_public_ports" "test" {
  instance_name = aws_lightsail_instance.server.name

    port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

    port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }
  
  port_info {
    protocol  = "tcp"
    from_port = 8001
    to_port   = 8001
  }



}