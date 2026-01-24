# Terraform EBS Volume Task Documentation

This document captures the details of creating an AWS EBS volume using Terraform as part of the Nautilus incremental migration strategy.

---

## Task Overview

The Nautilus DevOps team is migrating part of their infrastructure to AWS in incremental steps. As part of this, a task was to **create an EBS volume** using Terraform with the following requirements:

### Requirements

* **Volume Name:** `xfusion-volume`
* **Volume Type:** `gp3` (general-purpose SSD)
* **Volume Size:** 2 GiB
* **Region:** `us-east-1` (Availability Zone must be specified)
* **Terraform working directory:** `/home/bob/terraform`
* **File:** `main.tf` (update this file; do not create a new `.tf` file)

### Notes

* EBS volumes are **Availability Zone (AZ) specific**, so you must specify an AZ within the region (e.g., `us-east-1a`).
* Terraform will manage the creation, ensuring consistency and repeatability.

---

## Terraform Implementation

Add the following block to your existing `main.tf`:

```hcl
# Data source to get available AZs in the region
data "aws_availability_zones" "available" {}

# Create an EBS volume
resource "aws_ebs_volume" "xfusion_volume" {
  availability_zone = data.aws_availability_zones.available.names[0]  # Pick the first available AZ
  size              = 2
  type              = "gp3"

  tags = {
    Name = "xfusion-volume"
  }
}
```

### Notes:

1. `availability_zone` must be specified because EBS volumes cannot span multiple AZs. Using a data source ensures the AZ exists in the region.
2. `size` is in GiB.
3. `type` is set to `gp3` for general-purpose SSD performance.
4. `tags` provide easy identification of the volume in the AWS console.

---

## Terraform Apply

After updating `main.tf`, run:

```bash
cd /home/bob/terraform
terraform init      # Only if new providers or modules added
terraform apply -auto-approve
```

Terraform will create the EBS volume in the specified AZ with the given name, size, and type.

---

## What is an EBS Volume?

* **Elastic Block Store (EBS)** is a virtual hard drive that can be attached to EC2 instances.
* It provides **persistent, block-level storage**.
* Data persists even if the EC2 instance is stopped or terminated (unless `delete_on_termination` is set).
* Supports snapshots for backup and replication.
* Volume types like `gp3` offer high-performance SSD storage.

---

## Purpose of This Task

* **Incremental migration**: Creating storage volumes as separate resources helps the DevOps team migrate infrastructure in **manageable steps**.
* **Automation and consistency**: Terraform ensures volumes are created the same way every time and tracked in version control.
* **Future use**: The EBS volume can be attached to EC2 instances for data storage or used for snapshots and backups.

---

### TL;DR

> Create a **2 GiB gp3 EBS volume named `xfusion-volume`** in us-east-1 using Terraform. This volume serves as persistent block storage and is a building block for incremental migration tasks.

---

