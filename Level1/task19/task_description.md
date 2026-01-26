# AWS SNS Topic Creation using Terraform

## Task Overview

The Nautilus DevOps team needs to create an AWS SNS (Simple Notification Service) topic for sending notifications. The topic will act as a centralized notification channel, allowing AWS services and applications to publish messages that can be consumed by multiple subscribers for real-time notifications and event-driven processing.

This task is implemented using **Terraform** as part of Infrastructure as Code (IaC) practices.

---

## Requirements

* **Service**: Amazon SNS
* **Topic Name**: `datacenter-notifications`
* **Terraform Working Directory**: `/home/bob/terraform`
* **Terraform File**: `main.tf` only (no additional `.tf` files)
* **Validation**: `terraform plan` must return *No changes. Your infrastructure matches the configuration.*

---

## Terraform Configuration (`main.tf`)

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "datacenter_notifications" {
  name = "datacenter-notifications"
}
```

---

## Explanation of Terraform Arguments

* **provider.aws.region**: Specifies the AWS region (`us-east-1`)
* **aws_sns_topic**: Terraform resource for creating an SNS topic
* **name**: Name of the SNS topic (`datacenter-notifications`)

This configuration creates the topic only; it does not create subscribers or send messages yet.

---

## What This Task Does

* Creates an **SNS topic** in AWS named `datacenter-notifications`
* The topic serves as a **central hub for notifications**
* Applications and AWS services can later **publish messages** to this topic
* Subscribers (email, SMS, Lambda, SQS, HTTP endpoints) can receive these notifications

> Essentially, this is **Step 1** of setting up a notification system.

---

## How Other AWS Services Can Use This Topic

SNS topics allow **event-driven communication** between services:

| Publisher / Source            | SNS Topic                | Subscriber / Destination | Example Use Case                                  |
| ----------------------------- | ------------------------ | ------------------------ | ------------------------------------------------- |
| CloudWatch Alarm              | datacenter-notifications | Lambda                   | Automatic remediation when alarm triggers         |
| S3 Object Upload              | datacenter-notifications | SQS Queue                | Process newly uploaded objects in real-time       |
| CodePipeline                  | datacenter-notifications | Email                    | Notify team members of deployment success/failure |
| Any AWS service or custom app | datacenter-notifications | HTTP Endpoint            | Webhooks for custom processing                    |

* One message published to the SNS topic **fans out to all subscribers**
* SNS enables multiple AWS services to **react automatically** to events

---

## Important Notes

* SNS **does not store messages long-term**
* Messages are delivered **immediately** to all subscribers
* Subscribers must have **permissions** to receive messages
* SNS allows **event-driven workflows** and **fan-out architectures**

---

## Deployment Steps

1. Open VS Code
2. Navigate to `/home/bob/terraform`
3. Right-click in the Explorer → **Open in Integrated Terminal**
4. Run Terraform commands:

```bash
terraform init
terraform apply
```

* Approve the apply with `yes`
* Verify with:

```bash
terraform plan
```

Expected output:

```
No changes. Your infrastructure matches the configuration.
```

---

## TL;DR

> This task provisions an SNS topic named `datacenter-notifications` that acts as a central notification channel, allowing AWS services and applications to publish messages that are delivered to multiple subscribers for automated processing and event-driven workflows.

---


