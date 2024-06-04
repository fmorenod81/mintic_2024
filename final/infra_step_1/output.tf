output "public_of_ec2_instance"{
    value = aws_instance.simple[0].public_ip
}