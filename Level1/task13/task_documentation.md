# AWS S3 Bucket Access Control: ACL vs Public Access Block

## Overview

When managing AWS S3 buckets, there are multiple ways to control access:

1. **ACL (Access Control List)**
2. **Public Access Block**

Understanding the difference between these two mechanisms is important for securing S3 buckets properly, especially when using Terraform.

---

## 1️⃣ `aws_s3_bucket_acl`

**Purpose:**  
- ACL stands for **Access Control List**.  
- It defines **who can access the bucket and what actions they can perform** (read, write, full control).  

**Example ACLs:**  
- `private` → only bucket owner has access  
- `public-read` → anyone on the internet can read objects  
- `authenticated-read` → only AWS authenticated users can read  

**Behavior:**  
- Setting `acl = "private"` ensures the bucket is accessible only by the owner.  
- Setting `acl = "public-read"` allows public read access.  

**Limitation:**  
- If **S3 Public Access Block** is enabled, the ACL cannot override it.  
- ACL controls access, but **AWS safety settings can prevent it from taking effect**.

---

## 2️⃣ `aws_s3_bucket_public_access_block`

**Purpose:**  
- Explicitly **blocks or allows public access** to a bucket.  
- Provides four key settings:  
  1. `block_public_acls` → blocks public ACLs  
  2. `ignore_public_acls` → ignores public ACLs  
  3. `block_public_policy` → blocks public bucket policies  
  4. `restrict_public_buckets` → restricts public access to only bucket owner  

**Behavior:**  
- When enabled (`true`), **even a public ACL cannot make the bucket public**.  
- Acts as a **safety lock** on the bucket to prevent accidental public exposure.

---

## 3️⃣ Why both are used

In Terraform, a bucket can be configured like this:

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"
}

resource "aws_s3_bucket_acl" "example_acl" {
  bucket = aws_s3_bucket.example.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "example_block" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
