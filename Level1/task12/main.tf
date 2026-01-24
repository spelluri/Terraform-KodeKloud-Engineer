resource "aws_s3_bucket" "devops_s3_19928" {
    bucket = "devops-s3-19928"
    tags = {
        Name = "devops-s3-19928"
    }
}
resource "aws_s3_bucket_public_access_block" "devops_s3_19928_acl" {
    bucket = aws_s3_bucket.devops_s3_19928.id
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}