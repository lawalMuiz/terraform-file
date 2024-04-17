locals {
  ports = [80, 22, 443]
}
resource "aws_security_group" "mysg" {
  name        = "terraformSG"
  vpc_id = aws_vpc.myvpc.id
  description = "Inbound Rules for WebServer"

  dynamic "ingress" {
    for_each = local.ports
    content {
      description = "description ${ingress.key}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0a699202e5027c10d"
  instance_type = "t2.micro"
  availability_zone = "us-east-1d"
  key_name          = "${aws_key_pair.deployer.key_name}"
  security_groups = ["${aws_security_group.mysg.id}"]
  subnet_id       = "${aws_subnet.mysubnet.id}"
  

  tags = {
    Name = "terraform_ec2"
  }
}

resource "aws_key_pair" "deployer" { 
  key_name   = "terraform-key"
  public_key = file("${path.module}/my-key.pub")
}

