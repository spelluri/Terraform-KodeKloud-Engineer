# Terraform Task Documentation: IAM Group Creation (Kirsty DevOps)

## 📌 Task Overview

The Kirsty DevOps team is migrating services to AWS Cloud by breaking down the migration into smaller, manageable tasks. This approach helps with:

* Better control
* Risk mitigation
* Resource optimization

As part of this migration, the team needs to create an **AWS IAM Group** using **Terraform**.

---

## 🧩 Basics of AWS IAM Groups

### What is an IAM Group?

An **AWS IAM Group** is a collection of IAM users. Instead of assigning permissions to users individually, permissions are attached to a group, and all users in that group inherit those permissions.

### Key Characteristics of IAM Groups

* Groups **do not have credentials** (no access keys or passwords)
* Groups **cannot be assumed** like IAM roles
* Permissions are granted by attaching **IAM policies** to the group
* A user can belong to **multiple groups**
* Groups help enforce **least privilege** and simplify access management

### Why IAM Groups are Used

* Centralized permission management
* Easier onboarding and offboarding of users
* Reduced risk of misconfigured permissions
* Cleaner and more auditable IAM structure

### Common Real‑World Examples

* `devops-admins` → Admin access for DevOps engineers
* `developers-readonly` → Read-only access for developers
* `qa-engineers` → Limited access for testing environments

### IAM Group vs IAM Role (Quick Comparison)

| Feature          | IAM Group                       | IAM Role                           |
| ---------------- | ------------------------------- | ---------------------------------- |
| Used for         | Users                           | AWS services / external identities |
| Credentials      | No                              | No (assumed temporarily)           |
| Can be assumed   | ❌ No                            | ✅ Yes                              |
| Typical use case | Permission management for users | Service-to-service access          |

---

## 🎯 Objective

Create an IAM group named:

```
iamgroup_kirsty
```

using Terraform, following these constraints:

* Terraform working directory: `/home/bob/terraform`
* Configuration file: **main.tf only** (no additional `.tf` files)

---

## 🛠 Prerequisites

* AWS credentials configured (via environment variables, AWS CLI, or IAM role)
* Terraform installed
* Access to AWS IAM service

---

## 📂 Directory Structure

```
/home/bob/terraform
└── main.tf
```

---

## 📄 Terraform Configuration (main.tf)

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_group" "kirsty_group" {
  name = "iamgroup_kirsty"
}
```

### Explanation

* **provider "aws"**: Specifies AWS as the cloud provider and defines the region
* **aws_iam_group**: Terraform resource used to create an IAM group
* **name**: The actual IAM group name created in AWS

---

## 📍 IAM Group Path Behavior

### Default Path

The IAM group path is **not explicitly defined** in the configuration.

AWS automatically assigns the default path:

```
/
```

So the full IAM group path becomes:

```
/iamgroup_kirsty
```

### Equivalent Explicit Configuration

```hcl
resource "aws_iam_group" "kirsty_group" {
  name = "iamgroup_kirsty"
  path = "/"
}
```

---

## 🧭 Understanding IAM Paths

* IAM **paths are optional**
* Paths are used for **logical organization only**
* Paths **do NOT affect permissions**
* IAM policies are attached to users, groups, or roles — not paths

### Example of Custom Path Usage

```hcl
path = "/teams/kirsty/devops/"
```

Resulting group path:

```
/teams/kirsty/devops/iamgroup_kirsty
```

Used mainly in:

* Large enterprises
* Multi-team AWS environments
* Complex IAM structures

---

## ▶️ Terraform Execution Steps

1. Navigate to the working directory:

```bash
cd /home/bob/terraform
```

2. Initialize Terraform:

```bash
terraform init
```

3. Validate configuration:

```bash
terraform validate
```

4. Apply the configuration:

```bash
terraform apply
```

Confirm with `yes` when prompted.

---

## ✅ Expected Outcome

* An IAM group named **iamgroup_kirsty** is created in AWS
* Group path defaults to `/`
* Resource is fully managed by Terraform

---

## 🧠 Key DevOps Takeaways

* Terraform follows AWS defaults unless overridden
* IAM paths are organizational, not security-related
* Keeping IAM resources as code improves consistency and auditability

---

