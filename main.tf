provider "aws" {
region = "us-west-1"
}

resource "aws_instance" "web1" {
 ami = "ami-04534c96466647bfb"
 instance_type="t2.micro"

 tags {
 Name = "web1"
}
}

