terraform {
  required_version = ">= 0.10, <= 0.11.9"
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_launch_configuration" "web" {
  image_id               = "ami-04534c96466647bfb"
  instance_type          = "t2.micro"
  security_groups        = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
   lifecycle {
     create_before_destroy = true
   }
}

resource "aws_autoscaling_group" "web" {
   launch_configuration = "${aws_security_group.instance.id}"
   availability_zones   = ["${data.aws_availability_zones.all.names}"]

   min_size = 2
   max_size = 10 

   tag {
	key = "Name"
	value = "terraform-asg-web"
	propagate_at_launch = true
    }
 }

data "aws_availability_zones" "all" {}
resource "aws_security_group" "instance" {
  name = "terraform-instance-web"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["94.26.57.152/32"]
  }
  lifecycle {
    create_before_destroy = true
  }

}

