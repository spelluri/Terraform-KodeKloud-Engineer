# AWS DynamoDB Table Creation using Terraform

## Task Overview

The Nautilus DevOps team needs to provision a DynamoDB table on AWS for storing user-related data. This task is part of the foundational infrastructure setup using Infrastructure as Code (IaC) with Terraform.

---

## Requirements

1. **Table Name**: `datacenter-users`
2. **Primary Key (Partition Key)**: `datacenter_id`

   * Data type: **String**
3. **Billing Mode**: `PAY_PER_REQUEST` (On-Demand)
4. **Terraform Working Directory**: `/home/bob/terraform`
5. **Terraform File**: All configuration must be written in `main.tf` (no additional `.tf` files)

---

## DynamoDB Key Basics

DynamoDB supports only three data types for primary keys:

| DynamoDB Type | Terraform Value | Description                          |
| ------------- | --------------- | ------------------------------------ |
| String        | `S`             | Text-based identifiers (most common) |
| Number        | `N`             | Numeric values                       |
| Binary        | `B`             | Binary data                          |

In this task, `datacenter_id` is explicitly defined as a **String**, so Terraform uses:

```hcl
type = "S"
```

---

## Why `datacenter_id` is a String

* The requirement explicitly states that `datacenter_id` is of type **String**
* Identifiers are usually strings in real-world systems
* Strings allow flexible formats such as:

  * `dc-001`
  * `datacenter-us-east`
  * `prod-dc-123`

Using a string ensures future-proofing and avoids unnecessary constraints.

---

## Terraform Configuration (`main.tf`)

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "datacenter_users" {
  name         = "datacenter-users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "datacenter_id"

  attribute {
    name = "datacenter_id"
    type = "S"
  }

  tags = {
    Name        = "datacenter-users"
    Environment = "devops"
  }
}
```

---

## Explanation of Key Terraform Arguments

* **name**: Defines the DynamoDB table name
* **billing_mode**: `PAY_PER_REQUEST` enables on-demand capacity management
* **hash_key**: Specifies the partition key
* **attribute block**: Declares the key attribute and its data type
* **tags**: Optional but recommended for resource management

---

## Deployment Steps

1. Open VS Code
2. Navigate to `/home/bob/terraform`
3. Right-click in the Explorer → **Open in Integrated Terminal**
4. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

Confirm with `yes` when prompted.

---

## Verification (Without AWS Console Access)

You can verify creation using:

```bash
terraform state list
```

Expected output:

```text
aws_dynamodb_table.datacenter_users
```

You can also inspect details using:

```bash
terraform show
```

---

## Key Takeaways

* DynamoDB primary key attributes **must be explicitly defined**
* Terraform uses `S`, `N`, or `B` for DynamoDB attribute types
* `PAY_PER_REQUEST` removes the need for capacity planning
* Keeping everything in `main.tf` simplifies small tasks and assessments

---


