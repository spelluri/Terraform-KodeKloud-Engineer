# AWS Kinesis Data Stream Creation using Terraform

## Task Overview

The Nautilus DevOps team needs to create an AWS Kinesis Data Stream for real-time data processing. This stream will ingest large volumes of streaming data and allow downstream applications to consume it for analytics and real-time decision-making.

This task is implemented using **Terraform** as part of Infrastructure as Code (IaC) practices.

---

## Requirements

* **Service**: Amazon Kinesis Data Streams
* **Stream Name**: `devops-stream`
* **Stream Mode**: On-Demand
* **Terraform Working Directory**: `/home/bob/terraform`
* **Terraform File**: `main.tf` only (no additional `.tf` files)
* **Validation**: `terraform plan` must return *No changes. Your infrastructure matches the configuration.*

---

## Kinesis Stream Capacity Modes (Important Concept)

Amazon Kinesis supports **two mutually exclusive capacity modes**:

### 1. Provisioned Mode

* You must specify `shard_count`
* You manually manage capacity

```hcl
shard_count = 1
```

### 2. On-Demand Mode

* AWS automatically manages capacity
* `shard_count` must NOT be set
* Requires the `stream_mode` block

```hcl
stream_mode {
  stream_mode = "ON_DEMAND"
}
```

> **Rule to remember**: You must define **either** `shard_count` **or** `stream_mode`. Defining both or neither will result in an error.

---

## Why `stream_mode` Is Included in This Task

* The Terraform Registry marks `stream_mode` as a required block **when using On-Demand mode**
* This task does not specify shard-based capacity
* On-Demand mode is the safest and most flexible default
* Avoids manual shard management

---

## Terraform Configuration (`main.tf`)

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_kinesis_stream" "devops_stream" {
  name = "devops-stream"

  stream_mode {
    stream_mode = "ON_DEMAND"
  }
}
```

---

## Explanation of Terraform Arguments

* **provider.aws.region**: Specifies the AWS region (`us-east-1`)
* **aws_kinesis_stream**: Terraform resource for Kinesis Data Streams
* **name**: Name of the Kinesis stream
* **stream_mode block**:

  * Enables On-Demand capacity mode
  * AWS automatically scales shards internally

---

## Deployment Steps

1. Open VS Code
2. Navigate to `/home/bob/terraform`
3. Right-click in the Explorer → **Open in Integrated Terminal**
4. Run the following commands:

```bash
terraform init
terraform apply
```

Approve the apply when prompted.

---

## Verification

Run:

```bash
terraform plan
```

Expected output:

```text
No changes. Your infrastructure matches the configuration.
```

This confirms the stream is correctly created and Terraform state is in sync.

---

## Common Mistakes to Avoid

* ❌ Defining both `shard_count` and `stream_mode`
* ❌ Omitting both `shard_count` and `stream_mode`
* ❌ Creating multiple `.tf` files when explicitly restricted

---

## Key Takeaways

* Terraform arguments can be **conditionally required** based on configuration mode
* `stream_mode` is mandatory when using On-Demand Kinesis streams
* On-Demand mode simplifies operations and avoids capacity planning
* Always validate with `terraform plan` before submission

---