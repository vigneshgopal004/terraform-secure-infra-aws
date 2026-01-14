# ----------------------------
# Private S3 Bucket
# ----------------------------
resource "aws_s3_bucket" "private_bucket" {
  bucket = "secure-prod-private-bucket-vignesh"

  tags = {
    Name = "secure-prod-private-bucket"
  }
}

# ----------------------------
# Block ALL public access
# ----------------------------
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.private_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
