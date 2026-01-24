# Terraform AMI Creation Task Documentation

This document captures the details of creating an AMI from an existing EC2 instance using Terraform as part of the Nautilus incremental migration strategy.

---

## Task Overview

The Nautilus DevOps team is migrating part of their infrastructure to AWS in incremental steps. As part of this, a task was to **create an AMI from an existing EC2 instance** (`devops-ec2`) using Terraform.

### Requirements

* **Source EC2 instance**: `devops-ec2`
* **AMI Name**: `devops-ec2-ami`
* **AMI must be in** `available` state after creation
* **Terraform working directory**: `/home/bob/terraform`
* **File**: `main.tf` (update this file; do not create a separate `.tf` file)

### Notes

* The EC2 instance may be Terraform-managed or pre-existing in AWS.
* The AMI creation should **not reboot the EC2 instance** if possible (`snapshot_without_reboot = true`).

---

## Terraform Implementation

Add the following block to your existing `main.tf`:

```hcl
# Create an AMI from the existing EC2 instance
resource "aws_ami_from_instance" "devops_ami" {
  name                    = "devops-ec2-ami"
  source_instance_id      = aws_instance.xfusion_ec2.id  # reference your existing EC2 resource
  snapshot_without_reboot = true

  tags = {
    Name = "devops-ec2-ami"
  }
}
```

### Notes:

1. `source_instance_id` must reference the existing EC2 instance (`aws_instance.<name>.id`) if Terraform manages it.
2. If the EC2 instance is not Terraform-managed, use a **data source** to fetch the instance ID:

```hcl
data "aws_instance" "devops_ec2" {
  instance_id = "i-0abcd1234ef567890"  # Replace with actual instance ID
}
```

and then use:

```hcl
source_instance_id = data.aws_instance.devops_ec2.id
```

3. Run Terraform commands:

```bash
cd /home/bob/terraform
tf init
tf apply -auto-approve
```

Terraform will wait until the AMI is in the `available` state.

---

## Why `aws_ami_from_instance`?

* **Purpose:** Creates an AMI **directly from a running or stopped EC2 instance**, capturing its current state (OS, installed software, configurations).
* **AMI can later be used** to launch identical EC2 instances.
* This is required for **incremental migration** and creating backups or templates of the running instance.

### Why not `aws_ami_copy`?

* `aws_ami_copy` only **copies an existing AMI** to another region or account.
* It **cannot capture a running EC2 instance**.
* Use case: multi-region deployment or sharing AMIs, **not creating AMIs from live instances**.

### Why not `aws_ami`?

* `aws_ami` is typically used for **importing existing machine images** (like a snapshot or a public AMI) into your account.
* It **does not take a snapshot of a running EC2 instance**.
* For this task, we need to capture the current state of `devops-ec2`, so `aws_ami_from_instance` is the correct choice.

---

## TL;DR

* `aws_ami_from_instance` = create AMI from **live EC2 instance** (current task) ✅
* `aws_ami_copy` = copy an **existing AMI** to another region or account ❌
* `aws_ami` = import an existing AMI from a snapshot/public AMI ❌

**Key point:** This task ensures we have a **reusable, restorable, and versioned AMI** of the `devops-ec2` instance for scaling, backups, or incremental migration.

---


