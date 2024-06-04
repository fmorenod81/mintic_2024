resource "aws_s3_bucket" "example" {
    provider = aws.net
  bucket = "backup-fmorenod-mintic"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}