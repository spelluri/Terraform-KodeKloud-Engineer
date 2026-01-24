resource "aws_s3_bucket" "xfusion_s3_26200" {
    bucket = "xfusion-s3-26200"
    tags = {
       Name = "xfusion-s3-26200"
    }
}

resource "aws_s3_bucket_acl" "xfusion_s3_26200_acl" {
   bucket = aws_s3_bucket.xfusion_s3_26200.id
   acl = "private"
}