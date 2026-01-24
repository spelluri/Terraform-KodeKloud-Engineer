AWS S3 Public Bucket Terraform Task
Task Overview

The Nautilus DevOps team is creating a public S3 bucket in AWS as part of their migration and infrastructure setup. The bucket will be managed using Terraform.

Requirements:

Bucket name: devops-s3-9281

Region: us-east-1

Publicly accessible (ACL: public-read)

Managed entirely via Terraform

Terraform Implementation
1. Provider Configuration
provider "aws" {
  region = "us-east-1"
}


This ensures that all resources are created in the us-east-1 region.

2. Create the S3 Bucket
resource "aws_s3_bucket" "devops_s3_9281" {
  bucket = "devops-s3-9281"

  tags = {
    Name = "devops-s3-9281"
  }
}


Note:

Terraform resource names (devops_s3_9281) cannot contain hyphens; underscores must be used.

The bucket name itself can contain hyphens.

3. Handle Public Access Block
resource "aws_s3_bucket_public_access_block" "devops_s3_block" {
  bucket = aws_s3_bucket.devops_s3_9281.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


Why:
AWS accounts have Block Public Access enabled by default, which prevents ACLs from making a bucket public. Disabling the block allows the public ACL to take effect.

4. Apply Public ACL
resource "aws_s3_bucket_acl" "devops_s3_9281_acl" {
  bucket = aws_s3_bucket.devops_s3_9281.id
  acl    = "public-read"
}


This grants read access to all users (everyone on the internet).

How It Works

Bucket creation → aws_s3_bucket creates the S3 bucket.

Disable public block → aws_s3_bucket_public_access_block removes AWS’s default safety lock.

Apply ACL → aws_s3_bucket_acl sets the bucket to publicly readable.

ACL vs Public Access Block
Resource	Purpose	Key Notes
aws_s3_bucket_acl	Assigns basic permissions (e.g., public-read)	Legacy, resource-based. Only works if public access block is disabled
aws_s3_bucket_public_access_block	Controls whether AWS allows public access via ACL/policy	Must be disabled for ACLs to be honored

Analogy:

ACL → “I want the bucket public”

Public Access Block → “AWS safety lock on the bucket”

Best Practices

Labs/tasks: ACL + Public Access Block is acceptable.

Production: Prefer bucket policies + IAM roles over public ACLs.

Always reference the bucket using Terraform resource IDs, not hardcoded names, to maintain dependencies.

Terraform Commands
cd /home/bob/terraform
terraform init
terraform apply -auto-approve


Ensures the bucket is created in us-east-1.

Disables public access block.

Applies the public-read ACL successfully.