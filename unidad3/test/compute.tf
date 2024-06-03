# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon-linux-2" {
  provider = aws.l2group
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

resource "aws_eip_association" "eip_assoc" {
  provider = aws.l2group
  instance_id   = aws_instance.simple[0].id
  allocation_id = aws_eip.ec2_eip.id
}

resource "aws_instance" "simple" {
  provider = aws.l2group
  instance_type = "t2.micro"
  count = 1
  subnet_id = aws_subnet.public_subnet[1].id
  #associate_public_ip_address = true
  ami = data.aws_ami.amazon-linux-2.id
   vpc_security_group_ids = [ aws_security_group.public[1].id ]
  tags = {
    Name        = "Server_Ejercicio"
    Environment = "${var.environment}"
  }
  user_data = <<EOF
  #!/bin/bash
yum update -y
amazon-linux-extras install nginx1 -y
systemctl start nginx.service //Start Nginx Server
systemctl status nginx.service // Check Server Status
systemctl enable nginx.service // Enable Auto Server Start on Reboot
EOF

}
