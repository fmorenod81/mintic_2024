output "public_of_ec2_instance"{
    value = "http://{aws_instance.simple[0].public_ip}"
}
output "rds_endpoint"{
    value = aws_db_instance.dsdj-postgres-db-instance.address
}