##############################################################################################################
# VM LINUX for testing
##############################################################################################################
## Retrieve AMI info
data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "instance-dvwa" {
  ami                    = data.amazon-linux-2.ubuntu.id
  instance_type          = var.size
  key_name               = var.keyname
  network_interface {
    network_interface_id = aws_network_interface.instance-dvwa.id
    device_index         = 0
  }
  user_data = "${file("userdata.sh")}"
  tags = {
    Name     = "vm-dvwa-webserver"
  }
}

resource "aws_network_interface" "instance-dvwa" {
  subnet_id   = aws_subnet.dvwa-vpc-priv1.id
  private_ips = [cidrhost(var.dvwa-sn-cidr-pub1, 10)]
  security_groups = [aws_security_group.sgr-dvwa-webserver.id]

  tags = {
    Name = "vm-dvwa-webserver"
  }
}