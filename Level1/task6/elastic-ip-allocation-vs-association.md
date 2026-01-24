# Elastic IP Allocation vs EC2 Association (Terraform)

This document captures a common DevOps doubt encountered during AWS migrations using Terraform: **Why allocate an Elastic IP (EIP) to a VPC instead of directly attaching it to an EC2 instance?**

---

## Context

During incremental AWS migrations, infrastructure is often provisioned in phases. In one such task, the requirement was:

> Allocate an Elastic IP address named `nautilus-eip` using Terraform.

No EC2 instance was mentioned.

---

## Key Doubt

**Why are we assigning (allocating) an Elastic IP to a VPC and not directly to an EC2 instance?**

---

## Explanation

### 1. Allocation vs Association (Two Different Steps)

In AWS, Elastic IP lifecycle has **two separate actions**:

1. **Allocate** an Elastic IP (reserve a public IP)
2. **Associate** that Elastic IP with a resource (EC2, ENI, etc.)

Terraform reflects this separation clearly.

Allocating an EIP **does not automatically attach it** to anything.

---

### 2. What does `domain = "vpc"` mean?

```hcl
resource "aws_eip" "example" {
  domain = "vpc"
}
```

This means:

* The EIP is created **for use inside a VPC**
* It does **NOT** mean it is attached to an EC2 instance

AWS accounts today are VPC-only (EC2-Classic is deprecated), so this field is required.

---

### 3. Why not attach the EIP to EC2 immediately?

#### a) Task Scope

The task explicitly asked only to **allocate** an Elastic IP.

No EC2 instance was provided, so attaching it would be incorrect and out of scope.

#### b) Incremental Migration Strategy

In phased cloud migrations:

* IPs may be reserved early
* Firewalls or partner systems may whitelist the IP
* EC2 instances may be created later or replaced

Allocating first gives flexibility.

#### c) Terraform Best Practice

Terraform encourages **separation of concerns**:

* One resource to allocate the EIP
* One resource to associate it later

This avoids:

* Accidental IP re-creation
* Downtime during instance replacement
* Drift during scaling or rebuilds

---

## How to Attach the EIP Later (Reference)

Preferred approach:

```hcl
resource "aws_eip_association" "example" {
  allocation_id = aws_eip.example.id
  instance_id   = aws_instance.web.id
}
```

This method is safer and more flexible than attaching inline.

---

## Summary (TL;DR)

* `domain = "vpc"` only defines **where the EIP can be used**
* Allocation ≠ Association
* EIPs are often reserved **before** EC2 exists
* This aligns with:

  * Incremental AWS migrations
  * Terraform best practices
  * Real-world DevOps workflows

---

## Good to Know

* EC2-Classic is deprecated → VPC is mandatory
* EIPs can also be attached to:

  * Network Interfaces (ENI)
  * Load balancers (via NLB)
* In Auto Scaling setups, EIPs are usually avoided in favor of ALB/NLB

---


