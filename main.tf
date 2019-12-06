data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

 filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"]
}
resource "aws_instance" "web" {
  ami           = "ami-01758c85d695d39d9"
  instance_type = "t2.micro"
  key_name = "MyKeyPair"
  tags = {
   Name = "HelloWorld"
  }

security_groups = ["launch-wizard-1", "default"]
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
    ]
    connection {
      type = "ssh"
      host = "${aws_instance.web.public_ip}"
      #user = "centos"
      user = "ec2-user"
      #user = "root"
      #password = "Nthvbyfnjh120284"
      port = "22"
      agent = false
      #private_key = file("/home/puzik/.aws/MyKeyPair.pem")
      private_key = file("/home/puzik/.ssh/MyKeyPair.pem")
      #private_key = file("/home/puzik/.ssh/key.ppk")
      #private_key = file("/home/puzik/.aws/new.pem")
    }
  }
}


resource "aws_security_group" "launch-wizard-1" {
  name         = "secgrp"
  description  = "secgroup"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #agent = false 
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
  }
}




