output "id_of_ec2_instance"{
    value = aws_instance.simple[0].id
}