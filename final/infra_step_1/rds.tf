resource "aws_db_subnet_group" "default" {
    provider = aws.dba
  name       = "main"
  subnet_ids = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "dsdj-postgres-db-instance" {
    provider = aws.dba
  allocated_storage    = 40
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.private[0].id, aws_security_group.private[1].id]
  engine               = "postgres"
  engine_version       = "16.2"
  identifier           = "dsdj-postgres-db"
  instance_class       = "db.t3.micro"
  password             = "mypostgrespassword"
  skip_final_snapshot  = true
  storage_encrypted    = true
  publicly_accessible    = true
  username             = "postgres"
  apply_immediately = true
}