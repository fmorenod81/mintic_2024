# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "deployer" {
  provider = aws.app
  key_name   = var.name_of_keypair
  public_key = file("./my-key.pub")
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon-linux-2" {
    provider = aws.app
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

resource "aws_eip" "demo-eip" {
    provider = aws.app
  instance = aws_instance.simple[0].id
}

resource "aws_instance" "simple" {
    provider = aws.app
  instance_type = "t2.micro"
  count = 1
  subnet_id = aws_subnet.public_subnet[1].id
  key_name = aws_key_pair.deployer.id
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  ami = data.aws_ami.amazon-linux-2.id
   vpc_security_group_ids = [ aws_security_group.public[1].id ]
  tags = {
    Name        = "Server_Ejercicio"
    Environment = "${var.environment}"
  }
  user_data = <<EOF
  #!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo yum install -y postgresql13
sudo docker volume create cms_modules
sudo docker volume create cms_profiles
sudo docker volume create cms_themes
sudo docker volume create cms_sites
sudo docker pull drupal:10.2.6
sudo docker run -itd -p 80:80 --name drupalmain --volume cms_modules:/var/www/html/modules --volume cms_profiles:/var/www/html/profiles --volume cms_themes:/var/www/html/themes --volume cms_sites:/var/www/html/sites drupal:10.2.6
EOF

}
