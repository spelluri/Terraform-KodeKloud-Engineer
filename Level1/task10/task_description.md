# Terraform EBS Snapshot Task Documentation

This document captures the details of creating a snapshot of an existing AWS EBS volume using Terraform as part of the Nautilus incremental migration strategy.

---

## Task Overview

The Nautilus DevOps team is setting up automated backups for volumes in different AWS regions. As part of this, a task was to **create a snapshot of an existing EBS volume** using Terraform.

### Requirements

* **Source Volume:** `devops-vol` in `us-east-1` region
* **Snapshot Name:** `devops-vol-ss`
* **Description:** `Devops Snapshot`
* **Terraform working directory:** `/home/bob/terraform`
* **File:** `main.tf` (update this file; do not create a new `.tf` file)

### Notes

* Terraform will **wait until the snapshot status is `completed`** before finishing `apply`.
* You need the **Volume ID** of the existing volume, which can be found in the AWS Console or referenced if Terraform already manages the volume.

---

## Terraform Implementation

Add the following block to your existing `main.tf`:

```hcl
# Create a snapshot of an existing EBS volume
resource "aws_ebs_snapshot" "devops_vol_snapshot" {
  volume_id   = "vol-0123456789abcdef0"  # Replace with the actual Volume ID of devops-vol
  description = "Devops Snapshot"

  tags = {
    Name = "devops-vol-ss"
  }
}
```

### Notes:

1. **Volume ID**

   * Replace with the actual ID of `devops-vol`. If Terraform manages this volume, you can reference it directly:

   ```hcl
   volume_id = aws_ebs_volume.xfusion_volume.id
   ```

2. **Description**

   * Provides context for the snapshot (`Devops Snapshot`).

3. **Tags**

   * Name the snapshot `devops-vol-ss` for easy identification.

4. **Snapshot completion**

   * Terraform ensures the snapshot is fully completed before finishing the apply operation.

---

## Terraform Apply

After updating `main.tf`, run:

```bash
cd /home/bob/terraform
terraform init      # only if providers are new
terraform apply -auto-approve
```

Terraform will create the snapshot and ensure it is available and completed.

---

## What is an EBS Snapshot?

* An **EBS Snapshot** is a **point-in-time backup of an EBS volume**.
* Snapshots are stored in **S3** and can be used to restore or create new volumes.
* Snapshots can be shared across regions and accounts.
* They are incremental: only changes since the last snapshot are stored, saving storage costs.

---

## Purpose of This Task

* **Automated backup**: Ensures that important volume data can be safely backed up.
* **Incremental migration**: Capturing snapshots allows teams to move or replicate data gradually.
* **Disaster recovery**: Snapshots provide a restorable copy in case of accidental deletion or corruption.
* **Terraform management**: Infrastructure-as-code ensures snapshots are created consistently and tracked in version control.

---

### TL;DR

> Create a snapshot of the **existing EBS volume `devops-vol`** named `devops-vol-ss` with description `Devops Snapshot` using Terraform. The snapshot will be fully completed before Terraform finishes applying.

---

